//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import Foundation

struct OauthTokenResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case token
        case expires = "expired_at"
    }

    let token: String?
    let expires: Int?
}
