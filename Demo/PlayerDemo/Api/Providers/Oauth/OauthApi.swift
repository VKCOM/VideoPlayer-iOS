import Foundation


struct OauthApi: ApiProvider {
    
    let method: String
    
    
    init(_ method: String) {
        self.method = method
    }
    
    
    var fullPath: String {
        "https://oauth.vk.com/\(method)"
    }
    
    
    func decode<Body>(response: Data) throws -> Body where Body: Decodable {
        return try JSONDecoder().decode(Body.self, from: response)
    }
}
