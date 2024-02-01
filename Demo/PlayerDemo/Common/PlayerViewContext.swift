import OVKit


extension PlayerView {
    
    var demo_context: DemoPlayerViewContext? {
        get { context as? DemoPlayerViewContext }
        set { context = newValue }
    }
}


class DemoPlayerViewContext: PlayerViewContext {

    func canBeUsedForTransition(with playerView: OVKit.PlayerView?) -> Bool {
        true
    }

    var openWithDetail: Bool = false
}
