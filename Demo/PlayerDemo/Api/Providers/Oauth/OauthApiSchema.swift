import Foundation


struct OauthTokenResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case token,
             expires = "expired_at"
    }
    
    let token: String?
    let expires: Int?
}
