import UIKit
import OVKit


struct VKApiResponse<BodyType: Decodable>: Decodable {
    
    let response: BodyType?
    let error: VKApiError?
}


struct VKApiError: Decodable, Error {
    
    private enum CodingKeys: String, CodingKey {
        case code = "error_code",
             message = "error_msg"
    }
    
    enum Code: Int {
        case anonymousTokenHasExpired   = 1114
        case anonymousTokenIsInvalid    = 1116
    }
    
    let code: Int
    let message: String
}

// MARK: - Method Responses

struct VKApiVideoGetResponse: Decodable {
    
    let count: Int
    let items: [Video]
}
