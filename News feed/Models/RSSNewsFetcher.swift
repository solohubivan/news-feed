//
//  RSSNewsFetcher.swift
//  News feed
//
//  Created by Ivan Solohub on 22.10.2024.
//

import Foundation
import FeedKit
import Alamofire

class RSSNewsFetcher {
    
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
                let title = item.title ?? "No title"
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
        } else {
            
        }
    }
    
    private func getSourceName(from item: RSSFeedItem) -> String {
        if let feedSource = item.source?.value, !feedSource.isEmpty {
            return feedSource.lowercased()
        }
        
        if let link = item.link, let url = URL(string: link) {
            return url.host?
                .replacingOccurrences(of: "www.", with: "")
                .components(separatedBy: ".")
                .first?
                .lowercased() ?? "unknown source"
        }
        
        return "unknown source"
    }

    private func extractHighQualityImageUrl(from mediaContents: [MediaContent], thumbnail: [MediaThumbnail], description: String) -> String {
        
        let sortedMediaContents = mediaContents.sorted { ($0.attributes?.width ?? 0) > ($1.attributes?.width ?? 0) }
        for mediaContent in sortedMediaContents {
            if let url = mediaContent.attributes?.url, URL(string: url) != nil {
                return url
            }
        }
        
        let sortedThumbnails = thumbnail.sorted {
            (Int($0.attributes?.width ?? "") ?? 0) > (Int($1.attributes?.width ?? "") ?? 0)
        }
        for thumbnail in sortedThumbnails {
            if let url = thumbnail.attributes?.url, URL(string: url) != nil {
                return url
            }
        }
        
        let pattern = #"img src="([^"]+)""#
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: description.utf16.count)
            if let match = regex.firstMatch(in: description, options: [], range: range) {
                if let imageUrlRange = Range(match.range(at: 1), in: description) {
                    var imageUrl = String(description[imageUrlRange])
                    imageUrl = imageUrl.replacingOccurrences(of: "&amp;", with: "&")
                    
                    if URL(string: imageUrl) != nil {
                        return imageUrl
                    }
                }
            }
        }
        
        return ""
    }
}
