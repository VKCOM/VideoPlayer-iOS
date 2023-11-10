import OVKit


extension PreviewPlayButtonBehavior {
    
    static func feed(autoplay: Bool) -> PreviewPlayButtonBehavior {
        .init(withAutoplay: autoplay ? .hidden : .inactive,
              isActiveWhenAutoplayIsDisabled: false)
    }
}
