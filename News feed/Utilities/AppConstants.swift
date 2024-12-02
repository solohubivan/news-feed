//
//  AppConstants.swift
//  News feed
//
//  Created by Ivan Solohub on 02.12.2024.
//

import Foundation

enum AppConstants {
    
    enum Fonts {
        static let poppinsRegular = "Poppins-Regular"
        static let poppinsLight = "Poppins-Light"
        static let poppinsSemiBold = "Poppins-SemiBold"
    }
    
    enum Identifiers {
        static let nativeAdTableViewCellID = "NativeAdTableViewCell"
        static let newsFeedTableViewCellID = "NewsFeedTableViewCell"
    }
    
    enum ImagesNames {
        static let bookmarkSelected = "bookmarkSelected"
        static let bookmark = "bookmark"
        static let backArrow = "backArrow"
        static let wrenchFill = "wrench.fill"
        static let house = "house"
        static let magnifyingglass = "magnifyingglass"
        static let bell = "bell"
    }
    
    enum TimelineVC {
        static let titleLabelText = "Timeline"
    }
    
    enum NewsFeedTableViewCellCreator {
        static let year = "year"
        static let month = "month"
        static let week = "week"
        static let day = "day"
        static let hour = "hour"
        static let min = "min"
        static let ago = "ago"
        static let justNow = "Just now"
    }
    
    enum SearchingNewsVC {
        static let titleLabelText = "Search news here"
        static let tFPlaceholderText = "Find news here"
    }
    
    enum SavedNewsItemsVC {
        static let titleLabelText = "Saved"
    }
    
    enum NotificationsVC {
        static let comingSoonLabelText = "Coming soon"
    }
    
    enum AlertFactory {
        static let titleNoInternetConnection = "No internet connection"
        static let messagePleaseEnableInternetAccessOrUseTheAppInOffline = "Please enable internet access or use the app in offline mode."
        static let settingsButtonText = "Settings"
        static let titleInternetRestored = "Internet Restored"
        static let messageInternetRestored = "Your internet connection is back. Would you like to switch to online mode?"
        static let useOnlineButtonText = "Use online"
        static let keepOfflineButtonText = "Keep offline"
        static let messageNoInternetConnection = "We suggest adding the news to your saved items and viewing it in detail once an internet connection is established."
        static let oKButtonText = "OK"
    }
}
