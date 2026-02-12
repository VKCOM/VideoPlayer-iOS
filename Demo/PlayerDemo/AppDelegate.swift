//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import Metal
import os.log
import OVKit
import OVKitStatistics
import OVPlayerKit
import UIKit

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

        // Основная документация находится в OVLogger.h. Настройку логов следует выполнять опираясь на следующие рекомендации:
        // - logPrefix следует настраивать всегда
        // - события из logHandler следует направлять в консоль для debug
        // - события из fileLogHandler следует направлять в файл для анализа с прод билдов
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

        // Для использования VK Api (получения данных для проигрывания по video id) необходимо получить собственный Client Id и Client Secret.
        // В качестве userId необходимо использовать собственный идентификатор пользователя/устройства.

        let apiClientId = Environment.launchApiSessionClientId ?? UserDefaults.standard.string(forKey: Environment.demo_apiClientIdKey)
        let apiSecret = Environment.launchApiSessionSecret ?? UserDefaults.standard.string(forKey: Environment.demo_apiSecretKey)
        UserDefaults.standard.set(apiClientId, forKey: Environment.demo_apiClientIdKey)
        UserDefaults.standard.set(apiSecret, forKey: Environment.demo_apiSecretKey)
        if let apiClientId, !apiClientId.isEmpty, let apiSecret, !apiSecret.isEmpty {
            ApiSession.setup(clientId: apiClientId, secret: apiSecret)
        } else if let apiToken = ProcessInfo.processInfo.environment["API_SESSION_TOKEN"] {
            ApiSession.setup(sessionToken: apiToken)
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

        #if !OLD_ADS_OFF
        Environment.shared._enableInterstitial = false
        Environment.shared.defaultAdsProviderType = OVKitMyTargetPlugin.DefaultAdsProvider.self
        #endif
        Environment.shared.allowsExternalPlayback = true
        Environment.shared.allowsBackgroundPlayback = true
        Environment.shared.enableDiagnosticsView = true
        Environment.shared.autoShowDiagnosticsView = false
        Environment.shared._audioRouteChangeStrategy = NSNumber(value: 1)
        Environment._cmafAbrHarmonicCount = 12
        Environment.shared._fixURLParamsParser = true
        Environment.shared._fixPixelBufferCopy = true
        Environment.shared._allowMultiplayChangeDuringPlayback = true
        Environment._surfaceView = false
        Environment.shared._useNewBroadcast = false

        if ProcessInfo.processInfo.environment["DEMO_DISABLE_ANIMATIONS"] == "1" {
            UIView.setAnimationsEnabled(false)
        }
        if ProcessInfo.processInfo.environment["DEMO_AUTO_SHOW_DIAGNOSTICS_VIEW"] == "1" {
            Environment.shared.autoShowDiagnosticsView = true
        }

        if let rawFormat = ProcessInfo.processInfo.environment["DEMO_INITIAL_VIDEO_FORMAT"],
           let current = VideoFileFormat(rawValue: rawFormat) {
            Environment.shared.disabledFormats = Set(VideoFileFormat.allCases.filter { $0 != current })
        }

        if ProcessInfo.processInfo.environment["DEMO_START_WITH_LOWER_QUALITY"] == "1" {
            Environment.shared.startWithLowerQuality = true
        }

        if let bufferSize = ProcessInfo.processInfo.environment["DEMO_MAX_BUFFER_SIZE"],
           let bufferValue = TimeInterval(bufferSize) {
            // понижаем зону стабильности: 10/20 -> 3/5
            Environment.shared._videoBufferSettings = BufferSettings(
                maxBufferSize: bufferValue,
                minDurationForQualityIncrease: 3.0,
                maxDurationForQualityDecrease: 5.0
            )
        }

        AppCoordinator.shared.readEnvironmentParams()

        #if canImport(OVKitMyTargetPlugin)
        let disableAds = ProcessInfo.processInfo.environment["DEMO_DISABLE_ADS"] == "1"
        Environment.shared.myTargetPlugin = disableAds ? nil : MyTargetPluginImpl()
        Environment.shared._enableAnimatedControlsTranstions = true
        #endif

        #if canImport(OVKitChromecastPlugin)

        if let chromecastAppId = ProcessInfo.processInfo.environment["CHROMECAST_APP_ID"], !chromecastAppId.isEmpty {
            if Environment.shared._useNewBroadcast {
                BroadcastManager.shared.configure(providers: [ChromecastBroadcastServiceProvider(deviceAppChromecastID: chromecastAppId, priority: 1)])
            } else {
                Environment.chromecastPlugin = ChromecastPluginImpl(deviceAppChromecastID: chromecastAppId)
            }
        }
        #endif

        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        PersistenceManager.handleBackgroundSession(identifier: identifier, completionHandler: completionHandler)
    }
}
