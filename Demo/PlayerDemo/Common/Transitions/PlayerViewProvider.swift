import OVKit


protocol PlayerViewProvider: AnyObject {
    
    var currentPlayerView: PlayerView? { get }
    
    func didReceivePlayer()
}
