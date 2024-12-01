//
//  NetworkMonitor.swift
//  News feed
//
//  Created by Ivan Solohub on 25.11.2024.
//

import Alamofire

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let reachabilityManager = NetworkReachabilityManager()
    
    private var wasOffline: Bool = false
    var connectionMode: ConnectionMode = .online
    
    var onUseOfflineModeAllert: (() -> Void)?
    var onUseOnlineModeAllert: (() -> Void)?
    
    private init() {}
    
    func startMonitoring() {
        reachabilityManager?.startListening { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .notReachable:
                self.connectionMode = .offline
                self.wasOffline = true
                self.showNoInternetAlert()
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                self.connectionMode = .online
                if self.wasOffline {
                self.showInternetRestoredAlert()
                self.wasOffline = false
            }
            case .unknown:
                break
            }
        }
    }
    
    func stopMonitoring() {
        reachabilityManager?.stopListening()
    }
    
    private func showNoInternetAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        let alert = AlertFactory.noInternetAlert(
            onSettings: { },
            onCancel: { [weak self] in
                self?.onUseOfflineModeAllert?()
            }
        )
        
        rootViewController.present(alert, animated: true)
    }
    
    private func showInternetRestoredAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        let alert = AlertFactory.internetRestoredAlert(
            onUseOnline: {
                self.onUseOnlineModeAllert?()
            },
            onKeepOffline: { }
        )
            
        rootViewController.present(alert, animated: true)
    }
}
