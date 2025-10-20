//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit

protocol PlayerViewProvider: AnyObject {
    var currentPlayerView: PlayerView? { get }

    func didReceivePlayer()
}
