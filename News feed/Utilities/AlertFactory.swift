//
//  AlertFactory.swift
//  News feed
//
//  Created by Ivan Solohub on 26.11.2024.
//

import UIKit

class AlertFactory {
    
    static func noInternetAlert(onSettings: @escaping () -> Void, onUseOffline: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: AppConstants.AlertFactory.titleNoInternetConnection,
            message: AppConstants.AlertFactory.messagePleaseEnableInternetAccessOrUseTheAppInOffline,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: AppConstants.AlertFactory.settingsButtonText, style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            onSettings()
        }
        
        let cancelAction = UIAlertAction(title: AppConstants.AlertFactory.keepOfflineButtonText, style: .cancel) { _ in
            onUseOffline()
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    static func internetRestoredAlert(onUseOnline: @escaping () -> Void, onKeepOffline: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: AppConstants.AlertFactory.titleInternetRestored,
            message: AppConstants.AlertFactory.messageInternetRestored,
            preferredStyle: .alert
        )
                
        let useOnlineAction = UIAlertAction(title: AppConstants.AlertFactory.useOnlineButtonText, style: .cancel) { _ in
            onUseOnline()
        }
                
        let keepOfflineAction = UIAlertAction(title: AppConstants.AlertFactory.keepOfflineButtonText, style: .default) { _ in
            onKeepOffline()
        }
                
        alert.addAction(useOnlineAction)
        alert.addAction(keepOfflineAction)
            
        return alert
    }
    
    static func noInternetForNewsAlert(onOk: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(
            title: AppConstants.AlertFactory.titleNoInternetConnection,
            message: AppConstants.AlertFactory.messageNoInternetConnection,
            preferredStyle: .alert
        )
            
        let okAction = UIAlertAction(title: AppConstants.AlertFactory.oKButtonText, style: .default) { _ in
            onOk?()
        }
        alert.addAction(okAction)
        return alert
    }
}
