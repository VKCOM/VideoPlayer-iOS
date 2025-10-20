//
//  Copyright © 2024 - present, VK. All rights reserved.
//

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
        case .invalidRequest: return 0
        case .invalidResponse: return 1
        case .parse: return 2
        case .obtainToken: return 3
        case .vkApi: return 4
        case .videoCountDoesNotMatch: return 5
        case .vkVideoIdFormat: return 6
        }
    }

    var errorUserInfo: [String: Any] {
        switch self {
        case let .invalidResponse(error as NSError):
            return [NSUnderlyingErrorKey: error]

        case let .parse(error as NSError):
            return [NSUnderlyingErrorKey: error]

        case let .obtainToken(error as NSError):
            return [NSUnderlyingErrorKey: error]

        case let .vkApi(code, message):
            return [
                "code": code,
                "message": message,
            ]

        default:
            return [:]
        }
    }
}
