//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import Foundation

protocol ApiProvider {
    var fullPath: String { get }

    func decode<Body>(response: Data) throws -> Body where Body: Decodable
}
