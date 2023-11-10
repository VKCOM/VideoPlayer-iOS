import UIKit
import OVPlayerKit
import OVKit
import os.log

let logger = Logger(subsystem: "", category: "")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Demo: OVPlayerKit v\(Environment.versionOVPlayerKit), OVKit v\(Environment.versionOVKit), OVKResources v\(Environment.versionOVKResources)")
        
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
         Для использования VK Api (получения данный для проигрывания по video id) необходимо получить собственный Client Id и Client Secret.
         В качестве userId необходимо использовать собственный идентификатор пользователя/устройства.
         */
        ApiSession.setup(clientId: <#T##String#>, secret: <#T##String#>)
        Environment.shared.userId = <#T##String#>
        // Или
        // Environment.shared.userId = <#T##String#>
        // Environment.setupStatistics(appKey: <#T##String#>, tokenProvider: <#T##StatsTokenProvider#>)
                
        // При необходимости можно очистить кэш
        OVPlayer.cache.purgeDisk()
        
        
        return true
    }
}
