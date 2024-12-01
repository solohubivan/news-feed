//
//  AlertFactory.swift
//  News feed
//
//  Created by Ivan Solohub on 26.11.2024.
//

import UIKit

class AlertFactory {
    
    static func noInternetAlert(onSettings: @escaping () -> Void, onCancel: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "No internet connection",
            message: "Please enable internet access or use the app in offline mode.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            onSettings()
        }
        
        let cancelAction = UIAlertAction(title: "Use offline mode", style: .cancel) { _ in
            onCancel()
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    static func internetRestoredAlert(onUseOnline: @escaping () -> Void, onKeepOffline: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "Internet Restored",
            message: "Your internet connection is back. Would you like to switch to online mode?",
            preferredStyle: .alert
        )
                
        let useOnlineAction = UIAlertAction(title: "Use online", style: .cancel) { _ in
            onUseOnline()
        }
                
        let keepOfflineAction = UIAlertAction(title: "Keep offline", style: .default) { _ in
            onKeepOffline()
        }
                
        alert.addAction(useOnlineAction)
        alert.addAction(keepOfflineAction)
            
        return alert
    }
}
