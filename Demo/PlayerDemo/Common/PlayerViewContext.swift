import OVKit


extension PlayerView {
    
    var demo_context: DemoPlayerViewContext? {
        get { context as? DemoPlayerViewContext }
        set { context = newValue }
    }
}


class DemoPlayerViewContext: NSObject {
    var openWithDetail: Bool = false
}
