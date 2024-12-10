//
//  Untitled.swift
//  News feed
//
//  Created by Ivan Solohub on 29.10.2024.
//

import Foundation

class NewsFeedManager {

    private let rssNewsFetcher = RSSNewsService()
    private let atomNewsFetcher = RSSAtomNewsService()
    private var combinedNewsItems: [NewsItem] = []
    private var preparedNewsItems: [NewsItem] = []

    // MARK: - Public methods
    
    func getCombinedNewsItems() -> [NewsItem] {
        return combinedNewsItems
    }
    
    func fetchInitialNews(completion: @escaping () -> Void) {
        combinedNewsItems.removeAll()
        preparedNewsItems.removeAll()
        
        var nytimes: [NewsItem] = []
        var theGuardian: [NewsItem] = []
        var reddit: [NewsItem] = []

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        rssNewsFetcher.fetchRSSNews(from: NewsFeedLinks.nytimes) {
            nytimes = self.rssNewsFetcher.getNewsItems()
            self.preparedNewsItems.append(contentsOf: nytimes)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        rssNewsFetcher.fetchRSSNews(from: NewsFeedLinks.theGuardian) {
            theGuardian = self.rssNewsFetcher.getNewsItems()
            self.preparedNewsItems.append(contentsOf: theGuardian)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        atomNewsFetcher.fetchNews(from: NewsFeedLinks.reddit) {
            reddit = self.atomNewsFetcher.getNewsItems()
            self.preparedNewsItems.append(contentsOf: reddit)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            let allNews = nytimes + theGuardian + reddit
            let uniqueNews = self.removeDuplicates(from: allNews)

            self.combinedNewsItems.append(contentsOf: uniqueNews)
            self.combinedNewsItems.sort { $0.datePublished > $1.datePublished }
            
            completion()
        }
    }
    
    func fetchMoreNews(completion: @escaping () -> Void) {
        guard !preparedNewsItems.isEmpty else { return }
        let uniqueNewsItems = preparedNewsItems.filter { item in
            !combinedNewsItems.contains(where: { $0.title == item.title })
        }
        preparedNewsItems = uniqueNewsItems
        preparedNewsItems.sort { $0.datePublished > $1.datePublished }
        combinedNewsItems.append(contentsOf: preparedNewsItems)
        preparedNewsItems.removeAll()

        completion()
    }
    
    func fetchNewsFromCache(completion: @escaping () -> Void) {
        combinedNewsItems.removeAll()
        let cachedNews = NewsItemsCacheManager.shared.loadAllFromCache()
        let sortedCachedNews = cachedNews.sorted { $0.datePublished > $1.datePublished }
        combinedNewsItems.append(contentsOf: sortedCachedNews)
        completion()
    }
    
    func injectInitialData(combined: [NewsItem], prepared: [NewsItem]) {
        self.combinedNewsItems = combined
        self.preparedNewsItems = prepared
    }
    
    // MARK: - Private methods
    
    private func removeDuplicates(from news: [NewsItem]) -> [NewsItem] {
        var seenItems: [(String, Date)] = []
        return news.filter { newsItem in
            let identifier = (newsItem.title, newsItem.datePublished)
            guard !seenItems.contains(where: { $0.0 == identifier.0 && $0.1 == identifier.1 }) else { return false }
            seenItems.append(identifier)
            return true
        }
    }
}
