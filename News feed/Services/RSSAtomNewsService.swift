//
//  RSSAtomNewsService.swift
//  News feed
//
//  Created by Ivan Solohub on 29.10.2024.
//


import Foundation
import FeedKit

class RSSAtomNewsService {

    private var newsItems: [NewsItem] = []
    private var lastNewsID: String?

    // MARK: - Public methods

    func getNewsItems() -> [NewsItem] {
        return newsItems
    }

    func fetchNews(from url: String, completion: @escaping () -> Void) {
        guard let feedURL = URL(string: url) else {
            completion()
            return
        }
        
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync { [weak self] result in
            switch result {
            case .success(let feed):
                self?.parseFeed(feed)
                completion()
            case .failure(_):
                completion()
            }
        }
    }
    
    // MARK: - Private methods

    private func parseFeed(_ feed: Feed) {
        newsItems = []

        if let atomFeed = feed.atomFeed {
            for entry in atomFeed.entries ?? [] {
                let title = entry.title ?? ""
                let sourceName = entry.authors?.first?.name ?? ""
                let sourceLink = entry.links?.first?.attributes?.href ?? ""
                let datePublished = entry.published ?? Date()
                let content = entry.content?.value ?? ""
                let imageUrl = extractImageUrl(from: content)

                let newsItem = NewsItem(
                    title: title,
                    imageUrl: imageUrl,
                    imageData: nil,
                    sourceName: sourceName,
                    datePublished: datePublished,
                    sourceLink: sourceLink
                )
                newsItems.append(newsItem)
                
                if let id = entry.id {
                    lastNewsID = id
                }
            }
        }
    }

    private func extractImageUrl(from content: String) -> String {
        return ImageUrlParserService.extractImageUrlFromDescription(content) ?? ""
    }
}
