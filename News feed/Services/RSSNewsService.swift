//
//  RSSNewsService.swift
//  News feed
//
//  Created by Ivan Solohub on 22.10.2024.
//

import Foundation
import FeedKit
import Alamofire

class RSSNewsService {
    
    private var newsItems: [NewsItem] = []
    
    // MARK: - Public methods
    
    func getNewsItems() -> [NewsItem] {
        return newsItems
    }
    
    func fetchRSSNews(from url: String, completion: @escaping () -> Void) {
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
    
    private func parseFeed(_ feed: Feed) {
        newsItems = []
        
        if let rssFeed = feed.rssFeed {
            for item in rssFeed.items ?? [] {
                let title = item.title ?? ""
                let sourceLink = item.link ?? ""
                let datePublished = item.pubDate ?? Date()
                let description = item.description ?? ""
                
                let imageUrl = extractHighQualityImageUrl(from: item.media?.mediaContents ?? [], thumbnail: item.media?.mediaThumbnails ?? [], description: description)
                
                let sourceName = getSourceName(from: item)
                
                let newsItem = NewsItem(
                    title: title,
                    imageUrl: imageUrl, imageData: nil,
                    sourceName: sourceName,
                    datePublished: datePublished,
                    sourceLink: sourceLink
                )
                newsItems.append(newsItem)
            }
        }
    }
    
    private func getSourceName(from item: RSSFeedItem) -> String {
        guard let feedSource = item.source?.value, !feedSource.isEmpty else {
            guard let link = item.link, let url = URL(string: link) else { return "" }
            return url.host?
                .replacingOccurrences(of: "www.", with: "")
                .components(separatedBy: ".")
                .first?
                .lowercased() ?? ""
        }
        return feedSource.lowercased()
    }

    private func extractHighQualityImageUrl(from mediaContents: [MediaContent], thumbnail: [MediaThumbnail], description: String) -> String {
 
        let sources: [(String?)] = [
            extractImageUrlFromMediaContents(mediaContents),
            extractImageUrlFromThumbnails(thumbnail),
            extractImageUrlFromDescription(description)
        ]

        for source in sources {
            switch source {
            case let url? where !url.isEmpty:
                return url
            default:
                continue
            }
        }
        
        return ""
    }

    // MARK: - Helper Methods

    private func extractImageUrlFromMediaContents(_ mediaContents: [MediaContent]) -> String? {
        for mediaContent in mediaContents.sorted(by: { ($0.attributes?.width ?? 0) > ($1.attributes?.width ?? 0) }) {
            guard let url = mediaContent.attributes?.url, URL(string: url) != nil else { continue }
            return url
        }
        return nil
    }

    private func extractImageUrlFromThumbnails(_ thumbnails: [MediaThumbnail]) -> String? {
        for thumbnail in thumbnails.sorted(by: {
            (Int($0.attributes?.width ?? "") ?? 0) > (Int($1.attributes?.width ?? "") ?? 0)
        }) {
            guard let url = thumbnail.attributes?.url, URL(string: url) != nil else { continue }
            return url
        }
        return nil
    }

    private func extractImageUrlFromDescription(_ description: String) -> String? {
        return ImageUrlParserService.extractImageUrlFromDescription(description)
    }
}

