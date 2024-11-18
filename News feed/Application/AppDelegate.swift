//
//  AppDelegate.swift
//  News feed
//
//  Created by Ivan Solohub on 16.10.2024.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2ff9338dc57392a51f28b09dd5ccbd0f" ]
        return true
    }
}
