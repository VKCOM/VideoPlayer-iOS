import OVKit


extension PlayerView {
    
    var demo_context: PlayerViewContext? {
        get { context as? PlayerViewContext }
        set { context = newValue }
    }
}


class PlayerViewContext {
    
    var openWithDetail: Bool = false
}
