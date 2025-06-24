import UIKit
import OVPlayerKit
import OVKit
import os.log
import OVKitStatistics
import Metal

#if canImport(OVKitMyTargetPlugin)
import OVKitMyTargetPlugin
#endif
#if canImport(OVKitChromecastPlugin)
import OVKitChromecastPlugin
#endif

let logger = Logger(subsystem: "", category: "")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Demo: OVPlayerKit v\(Environment.versionOVPlayerKit), OVKit v\(Environment.versionOVKit), OVKResources v\(Environment.versionOVKResources)")

        PersistenceManager.warmup()
        
        /*
         Основная документация находится в OVLogger.h. Настройку логов следует выполнять опираясь на следующие рекомендации:
         - logPrefix следует настраивать всегда
         - события из logHandler следует направлять в консоль для debug
         - события из fileLogHandler следует направлять в файл для анализа с прод билдов
         */
        OVLogger.setLogPrefix("[OV]")
        OVLogger.setLogHandler { message in
            logger.debug("\(message)")
        }
        OVLogger.setFileLogHandler { message in
            logger.info("\(message)")
        }
        OVLogger.setLogCriticalErrorHandler { error in
            logger.error("\(error)")
        }
        
        /*
         Для использования VK Api (получения данных для проигрывания по video id) необходимо получить собственный Client Id и Client Secret.
         В качестве userId необходимо использовать собственный идентификатор пользователя/устройства.
         */

        let apiClientId = Environment.launchApiSessionClientId ?? UserDefaults.standard.string(forKey: Environment.demo_apiClientIdKey)
        let apiSecret = Environment.launchApiSessionSecret ?? UserDefaults.standard.string(forKey: Environment.demo_apiSecretKey)
        UserDefaults.standard.set(apiClientId, forKey: Environment.demo_apiClientIdKey)
        UserDefaults.standard.set(apiSecret, forKey: Environment.demo_apiSecretKey)
        if let apiClientId, !apiClientId.isEmpty, let apiSecret, !apiSecret.isEmpty {
            ApiSession.setup(clientId: apiClientId, secret: apiSecret)
        } else {
            print("API credentials not found in environment!")
        }

        // Если требуется отправка OneLog статистики, ее необходимо предварительно настроить:
        // OKApiSession.setup(appKey: <#T##String#>, userId: <#T##String?#>, tokenProvider: <#T##any StatsTokenProvider#>)

        StatsManager.shared.debugMode = true
        Environment.shared._oneLogV2 = true

        Environment.shared.userId = "2"
        Environment.shared.demo_bootstrapFromSettingsPersistence()

        // При необходимости можно очистить кэш
        OVPlayer.cache.purgeDisk()
        
        Environment.shared.allowsExternalPlayback = true
        Environment.shared.allowsBackgroundPlayback = true
        Environment.shared.enableDiagnosticsView = true

        Environment._cmafAbrHarmonicCount = 12

#if canImport(OVKitMyTargetPlugin)
        Environment.shared.myTargetPlugin = MyTargetPluginImpl()
        Environment._enableInstreamSupplementary = true
        Environment.shared._enableAnimatedControlsTranstions = true
#endif

#if canImport(OVKitChromecastPlugin)
        if let chromecastAppId = ProcessInfo.processInfo.environment["CHROMECAST_APP_ID"], !chromecastAppId.isEmpty {
            Environment.chromecastPlugin = ChromecastPluginImpl(deviceAppChromecastID: chromecastAppId)
        }
#endif
        // Not prod ready

        Environment.shared._audioCompressorParameters = AudioCompressorParameters()
        Environment._handleLowMemory = 10
        Environment._handleLowMemoryHardLevel = true
        Environment._metalYUVConverterGPUFamily = NSNumber(value: Int32(MTLGPUFamily.apple6.rawValue));

        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        PersistenceManager.handleBackgroundSession(identifier: identifier, completionHandler: completionHandler)
    }

    
}
