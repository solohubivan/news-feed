//
//  NewsItemsManager.swift
//  News feed
//
//  Created by Ivan Solohub on 04.11.2024.
//

import Foundation
import CoreData

class NewsItemsManager {
    
    private var savedItems: [NewsItem] = []
    
    private let context = CoreDataStack.shared.context

    init() {
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
            print("Failed to save item: \(error)")
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
            print("Failed to delete item: \(error)")
        }
    }
    
    func getSavedItems() -> [NewsItem] {
        return savedItems
    }
    
    func isNewsItemSaved(_ item: NewsItem) -> Bool {
        return savedItems.contains { $0.title == item.title && $0.datePublished == item.datePublished }
    }
    
    // MARK: - Private methods

    private func loadSavedItems() {
        let fetchRequest: NSFetchRequest<SavedNewsItems> = SavedNewsItems.fetchRequest()
        
        do {
            let savedNewsItems = try context.fetch(fetchRequest)
            savedItems = savedNewsItems.map { NewsItem(title: $0.title ?? "", imageUrl: $0.imageUrl ?? "", sourceName: $0.sourceName ?? "", datePublished: $0.datePublished ?? Date(), sourceLink: $0.sourceLink ?? "") }
        } catch {
            print("Failed to load saved items: \(error)")
        }
    }
}
