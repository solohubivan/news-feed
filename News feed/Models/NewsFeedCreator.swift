//
//  Untitled.swift
//  News feed
//
//  Created by Ivan Solohub on 29.10.2024.
//

import Foundation

class NewsFeedCreator {
    
    private let rssNewsFetcher = RSSNewsFetcher()
    private let atomNewsFetcher = RSSAtomNewsFetcher()
    
    private var combinedNewsItems: [NewsItem] = []
    
    // MARK: - Public methods
    
    func fetchCombinedNews(completion: @escaping () -> Void) {
        combinedNewsItems.removeAll()
        let dispatchGroup = DispatchGroup()
 
        dispatchGroup.enter()
        rssNewsFetcher.fetchNews(from: "https://www.theguardian.com/world/rss") {
            self.combinedNewsItems.append(contentsOf: self.rssNewsFetcher.getNewsItems())
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        rssNewsFetcher.fetchNews(from: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml") {
            self.combinedNewsItems.append(contentsOf: self.rssNewsFetcher.getNewsItems())
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        atomNewsFetcher.fetchNews(from: "https://www.reddit.com/.rss") {
            self.combinedNewsItems.append(contentsOf: self.atomNewsFetcher.getNewsItems())
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.combinedNewsItems.sort { $0.datePublished > $1.datePublished }
            completion()
        }
    }

    func getCombinedNewsItems() -> [NewsItem] {
        return combinedNewsItems
    }
}
