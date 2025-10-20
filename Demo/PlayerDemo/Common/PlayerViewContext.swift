//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit

extension PlayerView {
    var demo_context: DemoPlayerViewContext? {
        get { context as? DemoPlayerViewContext }
        set { context = newValue }
    }
}

class DemoPlayerViewContext: NSObject {
    var openWithDetail = false
}
