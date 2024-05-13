import Foundation


enum ApiSessionError: CustomNSError {
    /// Неверный запрос
    case invalidRequest
    /// Неверный ответ от сервера
    case invalidResponse(Error?)
    /// Ошибка парсинга ответа от сервера
    case parse(Error?)
    /// Ошибка при получении токена анонимной сессии
    case obtainToken(Error?)
    /// VK API ошибка
    case vkApi(code: Int, message: String)
    /// Не совпадает количество запрошенных видео с количеством объектов в ответе
    case videoCountDoesNotMatch
    /// Неверный формат VK Video ID
    case vkVideoIdFormat
    
    
    static var errorDomain: String {
        "OVKApiSessionError"
    }
    
    var errorCode: Int {
        switch self {
        case .invalidRequest:           return 0
        case .invalidResponse(_):       return 1
        case .parse(_):                 return 2
        case .obtainToken(_):           return 3
        case .vkApi(_, _):              return 4
        case .videoCountDoesNotMatch:   return 5
        case .vkVideoIdFormat:          return 6
        }
    }
    
    var errorUserInfo: [String: Any] {
        switch self {
        case .invalidResponse(let error as NSError):
            return [NSUnderlyingErrorKey: error]
            
        case .parse(let error as NSError):
            return [NSUnderlyingErrorKey: error]
            
        case .obtainToken(let error as NSError):
            return [NSUnderlyingErrorKey: error]
            
        case .vkApi(let code, let message):
            return [
                "code"      : code,
                "message"   : message,
            ]

        default:
            return [:]
        }
    }
}
