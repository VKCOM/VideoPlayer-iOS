//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import UIKit

class MenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        MenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
