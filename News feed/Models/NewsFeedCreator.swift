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
    
    func getCombinedNewsItems() -> [NewsItem] {
        return combinedNewsItems
    }

    func fetchNews(isInitialLoad: Bool, limit: Int, completion: @escaping () -> Void) {
        if isInitialLoad {
            combinedNewsItems.removeAll()
        }

        let dispatchGroup = DispatchGroup()
        var newFetchedNewsItems: [NewsItem] = []

        dispatchGroup.enter()
        rssNewsFetcher.fetchRSSNews(from: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml") {
            let newsItemsFromNYTimes = self.rssNewsFetcher.getNewsItems()
            newFetchedNewsItems.append(contentsOf: newsItemsFromNYTimes)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        rssNewsFetcher.fetchRSSNews(from: "https://www.theguardian.com/world/rss") {
            let newsItemsFromGuardian = self.rssNewsFetcher.getNewsItems()
            newFetchedNewsItems.append(contentsOf: newsItemsFromGuardian)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        atomNewsFetcher.fetchNewsAfterLastID(from: "https://www.reddit.com/.rss") {
            let newsItemsFromReddit = self.atomNewsFetcher.getNewsItems()
            newFetchedNewsItems.append(contentsOf: newsItemsFromReddit)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            let sortedNewsItems = newFetchedNewsItems.sorted { $0.datePublished > $1.datePublished }
            let uniqueNewsItems = sortedNewsItems.filter { item in
                !self.combinedNewsItems.contains(where: { $0.title == item.title })
            }

//            додай додавання новин із кешу
//            if uniqueNewsItems.isEmpty {
//                print("новини закінчились")
//                completion()
//                return
//            }

            let limitedItems = Array(uniqueNewsItems.prefix(limit))
            self.combinedNewsItems.append(contentsOf: limitedItems)
            completion()
        }
    }
}


//import Foundation
//
//class NewsFeedCreator {
//
//    private let rssNewsFetcher = RSSNewsFetcher()
//    private let atomNewsFetcher = RSSAtomNewsFetcher()
//    private var combinedNewsItems: [NewsItem] = []
//    
//    // Прапорці для позначення того, що новини закінчились
//    private var hasMoreNYTimesNews = true
//    private var hasMoreGuardianNews = true
//    private var hasMoreRedditNews = true
//
//    // MARK: - Public methods
//
//    func fetchNews(isInitialLoad: Bool, limit: Int, completion: @escaping () -> Void) {
//        if isInitialLoad {
//            combinedNewsItems.removeAll()
//            // Скидаємо прапорці на початку
//            hasMoreNYTimesNews = true
//            hasMoreGuardianNews = true
//            hasMoreRedditNews = true
//        }
//
//        let dispatchGroup = DispatchGroup()
//        var newFetchedNewsItems: [NewsItem] = []
//
//        if hasMoreNYTimesNews {
//            dispatchGroup.enter()
//            rssNewsFetcher.fetchRSSNews(from: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml") {
//                let newsItemsFromNYTimes = self.rssNewsFetcher.getNewsItems()
//                
//                if newsItemsFromNYTimes.isEmpty {
//                    self.hasMoreNYTimesNews = false // Позначаємо, що новин більше нема
//                } else {
//                    newFetchedNewsItems.append(contentsOf: newsItemsFromNYTimes)
//                }
//                
//                dispatchGroup.leave()
//            }
//        }
//
//        if hasMoreGuardianNews {
//            dispatchGroup.enter()
//            rssNewsFetcher.fetchRSSNews(from: "https://www.theguardian.com/world/rss") {
//                let newsItemsFromGuardian = self.rssNewsFetcher.getNewsItems()
//                
//                if newsItemsFromGuardian.isEmpty {
//                    self.hasMoreGuardianNews = false // Позначаємо, що новин більше нема
//                } else {
//                    newFetchedNewsItems.append(contentsOf: newsItemsFromGuardian)
//                }
//                
//                dispatchGroup.leave()
//            }
//        }
//
//        if hasMoreRedditNews {
//            dispatchGroup.enter()
//            atomNewsFetcher.fetchNewsAfterLastID(from: "https://www.reddit.com/.rss") {
//                let newsItemsFromReddit = self.atomNewsFetcher.getNewsItems()
//                
//                if newsItemsFromReddit.isEmpty {
//                    self.hasMoreRedditNews = false // Позначаємо, що новин більше нема
//                } else {
//                    newFetchedNewsItems.append(contentsOf: newsItemsFromReddit)
//                }
//                
//                dispatchGroup.leave()
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            let sortedNewsItems = newFetchedNewsItems.sorted { $0.datePublished > $1.datePublished }
//            let uniqueNewsItems = sortedNewsItems.filter { item in
//                !self.combinedNewsItems.contains(where: { $0.title == item.title })
//            }
//
//            if uniqueNewsItems.isEmpty && !isInitialLoad {
//                print("Новини закінчились або більше нема нових елементів.")
//                completion()
//                return
//            }
//
//            let limitedItems = Array(uniqueNewsItems.prefix(limit))
//            self.combinedNewsItems.append(contentsOf: limitedItems)
//            completion()
//        }
//    }
//
//    func getCombinedNewsItems() -> [NewsItem] {
//        return combinedNewsItems
//    }
//}
