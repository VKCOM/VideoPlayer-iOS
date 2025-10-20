//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import Foundation

struct VKApi: ApiProvider {
    let method: String

    init(_ method: String) {
        self.method = method
    }

    var fullPath: String {
        "https://api.vk.com/method/\(method)"
    }

    func decode<Body>(response: Data) throws -> Body where Body: Decodable {
        let decoded = try JSONDecoder().decode(VKApiResponse<Body>.self, from: response)
        guard let response = decoded.response else {
            throw decoded.error ?? VKApiError(code: 0, message: "")
        }

        return response
    }
}
