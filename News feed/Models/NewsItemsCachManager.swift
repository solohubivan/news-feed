//
//  NewsItemsCacheManager.swift
//  News feed
//
//  Created by Ivan Solohub on 04.11.2024.
//

import Foundation
import CoreData
import Alamofire

class NewsItemsCacheManager {
    
    static let shared = NewsItemsCacheManager()
    private let context = CoreDataStack.shared.context
    
    private var savedItems: [NewsItem] = []

    private init() {
        loadSavedItems()
    }
    
    // MARK: - Public methods
    
    func saveNewsItem(_ item: NewsItem) {
        let savedNewsItem = SavedNewsItems(context: context)
        savedNewsItem.title = item.title
        savedNewsItem.imageUrl = item.imageUrl
        savedNewsItem.sourceName = item.sourceName
        savedNewsItem.datePublished = item.datePublished
        savedNewsItem.sourceLink = item.sourceLink
        
        do {
            try context.save()
            savedItems.append(item)
        } catch {
            
        }
    }

    func deleteNewsItem(_ item: NewsItem) {
        let fetchRequest: NSFetchRequest<SavedNewsItems> = SavedNewsItems.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND datePublished == %@", item.title, item.datePublished as CVarArg)

        do {
            let itemsToDelete = try context.fetch(fetchRequest)
            for item in itemsToDelete {
                context.delete(item)
            }
            try context.save()
            savedItems.removeAll { $0.title == item.title && $0.datePublished == item.datePublished }
        } catch {
            
        }
    }
    
    func getSavedItems() -> [NewsItem] {
        return savedItems
    }

    func isNewsItemSaved(_ item: NewsItem) -> Bool {
        return savedItems.contains { $0.title == item.title && $0.datePublished == item.datePublished }
    }

    func saveAllToCache(_ items: [NewsItem]) {
        context.perform { [weak self] in
            guard let self = self else { return }

            items.forEach { item in
                let fetchRequest: NSFetchRequest<CashedNewsItems> = CashedNewsItems.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title == %@ AND datePublished == %@", item.title, item.datePublished as CVarArg)

                do {
                    let existingItems = try self.context.fetch(fetchRequest)
                    if existingItems.isEmpty {
                        let cachedNewsItem = CashedNewsItems(context: self.context)
                        cachedNewsItem.title = item.title
                        cachedNewsItem.imageUrl = item.imageUrl
                        cachedNewsItem.sourceName = item.sourceName
                        cachedNewsItem.datePublished = item.datePublished
                        cachedNewsItem.sourceLink = item.sourceLink

                        if let imageUrlString = item.imageUrl, let url = URL(string: imageUrlString) {
                            AF.request(url).responseData { response in
                                switch response.result {
                                case .success(let data):
                                    self.context.perform {
                                        cachedNewsItem.imageData = data
                                        do {
                                            try self.context.save()
                                        } catch _ {
                                        }
                                    }
                                case .failure(_):
                                    break
                                }
                            }
                        } else {
                            cachedNewsItem.imageData = nil
                        }
                    }
                } catch _ {

                }
            }
        }
    }
    
    func loadAllFromCache() -> [NewsItem] {
        let fetchRequest: NSFetchRequest<CashedNewsItems> = CashedNewsItems.fetchRequest()
        do {
            let cachedNewsItems = try context.fetch(fetchRequest)
            return cachedNewsItems.map {
                NewsItem(
                    title: $0.title ?? "",
                    imageUrl: $0.imageUrl,
                    imageData: $0.imageData,
                    sourceName: $0.sourceName ?? "",
                    datePublished: $0.datePublished ?? Date(),
                    sourceLink: $0.sourceLink ?? ""
                )
            }
        } catch {

            return []
        }
    }
    
    // MARK: - Private methods
    
    private func loadSavedItems() {
        let fetchRequest: NSFetchRequest<SavedNewsItems> = SavedNewsItems.fetchRequest()
        
        do {
            let savedNewsItems = try context.fetch(fetchRequest)
            savedItems = savedNewsItems.map { savedItem in
                NewsItem(
                    title: savedItem.title ?? "",
                    imageUrl: savedItem.imageUrl,
                    imageData: savedItem.imageData,
                    sourceName: savedItem.sourceName ?? "",
                    datePublished: savedItem.datePublished ?? Date(),
                    sourceLink: savedItem.sourceLink ?? ""
                )
            }
        } catch {

        }
    }
}
