import UIKit
import OVKit


/// Класс для работы с апи сессией ВКонтакте. Позволяет получать объекты ``Video`` по их `id`.
class ApiSession: NSObject {
    
    private let timeoutInterval: TimeInterval = 30.0
    
    private let clientId: String
    private let clientSecret: String
    private let isAnonymous: Bool
    private let apiVersion = "5.226"

    private let accessTokenStorageKey = "ovk.api.session.token"
    private let storage = UserDefaults.standard
    private var accessToken: String? {
        get {
            storage.string(forKey: accessTokenStorageKey)
        }
        set {
            storage.set(newValue, forKey: accessTokenStorageKey)
        }
    }
        
    /// Очередь, в которую складываются запросы, которые не могут выполниться в данный момент
    private var requestQueue: [() -> ()] = []
    private func runRequestQueue() {
        let queue = requestQueue
        requestQueue = []
        
        for request in queue {
            request()
        }
    }
    
    /**
     Означает, что в данный момент идет обновление токена сессии, и все запросы должны быть помещены в очередь. После обновления все отложенные запросы будут выполнены.
     */
    private var tokenRefreshInProgress: Bool = false {
        didSet {
            if !tokenRefreshInProgress {
                DispatchQueue.main.async {
                    self.runRequestQueue()
                }
            }
        }
    }
    
    /// Общая сессия для выполнения запросов. Имеет значение `nil` до вызова метода `setup(clientId:secret:)`.
    @objc public private(set) static var shared: ApiSession?
    
    /**
     Первичная настройка сессии идентификатором и секретным ключом. Сразу после настройки автоматически делается запрос на получение токена сессии.
     
     - Parameter clientId:   Идентификатор клиентского приложения.
     - Parameter secret:     Секретный ключ приложения.
     
     Необходимо настраивать один раз на старте приложения. До установки ``Environment/userId``.
     При смене пользователя  (``Environment/userId``) также необходимо вызывать метод.
     */
    @objc public static func setup(clientId: String, secret: String) {
        let session = ApiSession(with: clientId, secret: secret, isAnonymous: true)
        if !session.isValid {
            session.obtainToken(completion: nil)
        }
        shared = session
    }


    @objc public static func setup(sessionToken: String, isAnonymous: Bool = false) {
        let session = ApiSession(with: "", secret: "There's No Secrets This Year", isAnonymous: isAnonymous)
        session.accessToken = sessionToken
        shared = session
    }

    
    // MARK: - Initialization
    
    private init(with id: String, secret: String, isAnonymous: Bool) {
        self.clientId = id
        self.clientSecret = secret
        self.isAnonymous = isAnonymous
    }
    
    
    // MARK: - Requests
    
    /**
     Выполняет запрос на получение данных о видеозаписях. Обязательно должен вызываться на главном потоке.
     
     - Parameter videoIds:      Список `id` видеозаписей.
     - Parameter completion:    Вызывается при завершении выполнения запроса. Если параметр ошибки является `nil`, значит запрос был выполнен успешно.
     */
    @objc public func fetch(videoIds: [String], completion: @escaping ([Video]?, NSError?) -> ()) {
        guard !videoIds.isEmpty else {
            completion([], nil)
            return
        }
        
        performRequest(
            to: VKApi("video.get"),
            params: [
                "videos" : videoIds.joined(separator: ","),
            ],
            requireAuth: true
        ) { (result: Result<VKApiVideoGetResponse, ApiSessionError>) in
            switch result {
            case .failure(let error):
                completion(nil, error as NSError)
                
            case .success(let response):
                guard response.count == videoIds.count else {
                    completion(nil, ApiSessionError.videoCountDoesNotMatch as NSError)
                    return
                }
                completion(response.items, nil)
            }
        }
    }
    
    /**
     Выполняет запрос на получение видеозаписей пользователя или сообщества по переданному идентификатору.
     
     - Parameter ownerId:   VK Id страницы или сообщества для получения видеозаписей.
     - Parameter count:     Количество запрашиваемых видеозаписей. По умолчанию – `10`.
     - Parameter offset:    Смещение относительно первой найденной видеозаписи для выборки определенного подмножества. По умолчанию – `0`.
     - Parameter completion: Вызывается при завершении выполнения запроса.
     */
    @objc public func fetch(ownerVideos ownerId: String,
                            count: UInt = 10,
                            offset: UInt = 0,
                            completion: @escaping ([Video]?, NSError?) -> ()) {

        performRequest(
            to: VKApi("video.get"),
            params: [
                "owner_id" : ownerId,
                "count"    : String(count),
                "offset"   : String(offset),
            ],
            requireAuth: true
        ) { (result: Result<VKApiVideoGetResponse, ApiSessionError>) in
            switch result {
            case .failure(let error):
                completion(nil, error as NSError)
                
            case .success(let response):
                completion(response.items, nil)
            }
        }
    }
    
    
    private func obtainToken(completion: ((ApiSessionError?) -> ())?) {
        tokenRefreshInProgress = true
        performRequest(
            to: OauthApi("get_anonym_token"),
            params: [
                "client_id"     : clientId,
                "client_secret" : clientSecret,
                "device_id"     : Environment.deviceId
            ],
            requireAuth: false
        ) { [weak self] (result: Result<OauthTokenResponse, ApiSessionError>) in
            guard let self = self else { return }
                        
            switch result {
            case .failure(let error):
                self.tokenRefreshInProgress = false
                completion?(.obtainToken(error))
                
            case .success(let response):
                guard let token = response.token else {
                    self.tokenRefreshInProgress = false
                    completion?(.obtainToken(nil))
                    return
                }
                
                self.accessToken = token
                self.tokenRefreshInProgress = false
                completion?(nil)
            }
        }
    }
    
    // MARK: - API Helpers
    
    private var isValid: Bool {
        accessToken != nil
    }
    
    // Нужно вызывать на главном потоке, либо на любой серийной очереди
    private func performRequest<ResponseType: Decodable>(
        to method: ApiProvider,
        params: [String: String],
        requireAuth: Bool,
        completion: @escaping (Result<ResponseType, ApiSessionError>) -> ()
    ) {
        assert(Thread.isMainThread)
        
        guard let request = buildRequest(for: method, query: params) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        if requireAuth, !isValid {
            let requestBlock: () -> () = { [weak self] in
                self?.performRequest(to: method,
                                     params: params,
                                     requireAuth: requireAuth,
                                     completion: completion)
            }
            
            /*
             Если в данный момент уже запрашивается токен, откладываем запрос в очередь.
             После получения токена он перезапустится заново.
             */
            if tokenRefreshInProgress {
                requestQueue.append(requestBlock)
                return
            }
            
            obtainToken { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(.obtainToken(error)))
                        return
                    }
                    
                    requestBlock()
                }
            }
            return
        }

        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
                
            if let error = error {
                completion(.failure(.invalidResponse(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse(nil)))
                return
            }

            do {
                let body: ResponseType = try method.decode(response: data)
                completion(.success(body))
            } catch let error as VKApiError {
                // Можем ли мы автоматически обработать полученный код ошибки
                guard let handlableError = VKApiError.Code(rawValue: error.code) else {
                    completion(.failure(.vkApi(code: error.code, message: error.message)))
                    return
                }
                
                switch handlableError {
                case .anonymousTokenIsInvalid, .anonymousTokenHasExpired:
                    self.accessToken = nil
                    DispatchQueue.main.async {
                        self.performRequest(
                            to: method,
                            params: params,
                            requireAuth: requireAuth,
                            completion: completion
                        )
                    }
                }
            } catch let error as ApiSessionError {
                completion(.failure(error))
            } catch let error {
                completion(.failure(.invalidResponse(error)))
            }
        }
        
        dataTask.resume()
    }
        
    
    private func buildRequest(for method: ApiProvider, query params: [String: String]) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: method.fullPath) else {
            return nil
        }
        
        var p = params
        p["v"]      = apiVersion
        p[tokenKey] = accessToken

        urlComponents.queryItems = p.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: timeoutInterval
        )
    }


    private var tokenKey: String {
        isAnonymous ? "anonymous_token" : "access_token"
    }
}
