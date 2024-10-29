import Foundation
import OVKit


extension Environment {

    static var demo_userIdKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment.userId))" }
    static var demo_advDebugKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment._advDebug))" }
    static var demo_advExpIdKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment._advExpId))" }
    static var demo_advCustomSlotIdKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment._advCustomSlotId))" }
    static var demo_advCustomCreativeTypeKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment._advCustomCreativeType))" }
    static var demo_advDeviceIdKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment._advDeviceId))" }
    static var demo_enableMotionAdKey: String { "\(String(describing: Environment.self)).\(#keyPath(OVKit.Environment._enableMotionAd))" }
#if DEBUG
    static var demo_focusDebug: String { "\(String(describing: Environment.self)).\(#keyPath(SettingsViewController.focusDebug))" }
#endif

    static var demo_hlsDownload: String { "\(String(describing: Environment.self)).\(#keyPath(SettingsViewController.useHLS))" }

    static let demo_apiClientIdKey = "demo_apiClientId"
    static let demo_apiSecretKey = "demo_apiSecret"

    func demo_bootstrapFromSettingsPersistence() {
        if let uid = UserDefaults.standard.string(forKey: Environment.demo_userIdKey), uid.count > 0 {
            userId = uid
        }
        if UserDefaults.standard.object(forKey: Environment.demo_advDebugKey) != nil {
            _advDebug = UserDefaults.standard.bool(forKey: Environment.demo_advDebugKey)
        }
        if let advExpId = UserDefaults.standard.string(forKey: Environment.demo_advExpIdKey), advExpId.count > 0 {
            _advExpId = advExpId
        }
        if let advCustomSlotId = UserDefaults.standard.object(forKey: Environment.demo_advCustomSlotIdKey), let slotId = advCustomSlotId as? NSString {
            _advCustomSlotId = NSNumber(value: slotId.integerValue)
        }
        if let advCustomCreativeType = UserDefaults.standard.object(forKey: Environment.demo_advCustomCreativeTypeKey), let type = advCustomCreativeType as? String {
            _advCustomCreativeType = type
        }
        if let advDeviceId = UserDefaults.standard.string(forKey: Environment.demo_advDeviceIdKey), advDeviceId.count > 0 {
            _advDeviceId = advDeviceId
        }
        if UserDefaults.standard.object(forKey: Environment.demo_enableMotionAdKey) != nil {
            Environment._enableMotionAd = UserDefaults.standard.bool(forKey: Environment.demo_enableMotionAdKey)
        }
#if DEBUG
        if UserDefaults.standard.object(forKey: Environment.demo_focusDebug) != nil {
            SettingsViewController.focusDebug = UserDefaults.standard.bool(forKey: Environment.demo_focusDebug)
        }
#endif
        if UserDefaults.standard.object(forKey: Environment.demo_hlsDownload) != nil {
            SettingsViewController.useHLS = UserDefaults.standard.bool(forKey: Environment.demo_hlsDownload)
        }
    }


    static var launchApiSessionClientId: String? {
        ProcessInfo.processInfo.environment["API_SESSION_CLIENT_ID"]
    }

    static var launchApiSessionSecret: String? {
        ProcessInfo.processInfo.environment["API_SESSION_SECRET"]
    }
}
