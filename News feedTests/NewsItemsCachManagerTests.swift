//
//  NewsItemsCachManagerTests.swift
//  News feedTests
//
//  Created by Ivan Solohub on 09.12.2024.
//

import XCTest
@testable import News_feed

final class NewsItemsCacheManagerTests: XCTestCase {
    
    var cacheManager: NewsItemsCacheManager?
    
    override func setUp() {
        super.setUp()
        cacheManager = NewsItemsCacheManager()
    }
    
    func testSaveNewsItem() {
        // Given
        guard let cacheManager = cacheManager else { return }
        let newsItemToSave = NewsItem(
            title: "Test News",
            imageUrl: "https://example.com/image.png",
            imageData: nil,
            sourceName: "Test Source",
            datePublished: Date(),
            sourceLink: "https://example.com/news"
        )
        // When
        cacheManager.saveNewsItem(newsItemToSave)
        // Then
        let savedItems = cacheManager.getSavedItems()
        XCTAssertTrue(savedItems.contains(where: { $0.title == newsItemToSave.title }), "The news item should be saved in the cache.")
    }
    
    func testDeleteNewsItem() {
        // Given
        guard let cacheManager = cacheManager else { return }
        let newsItemToSaveAndDelete = NewsItem(
            title: "Test News For Deletion",
            imageUrl: "https://example.com/image.png",
            imageData: nil,
            sourceName: "Test Source",
            datePublished: Date(),
            sourceLink: "https://example.com/news"
        )
        // Save the news item first
        cacheManager.saveNewsItem(newsItemToSaveAndDelete)
        XCTAssertTrue(cacheManager.isNewsItemSaved(newsItemToSaveAndDelete), "The news item should be saved before deletion.")
        // When
        cacheManager.deleteNewsItem(newsItemToSaveAndDelete)
        // Then
        let savedItems = cacheManager.getSavedItems()
        XCTAssertFalse(savedItems.contains(where: { $0.title == newsItemToSaveAndDelete.title }), "The news item should be deleted from the cache.")
    }
    
    func testIsNewsItemSaved() {
        // Given
        guard let cacheManager = cacheManager else { return }
        let savedNewsItem = NewsItem(
            title: "Saved News",
            imageUrl: nil,
            imageData: nil,
            sourceName: "Test Source",
            datePublished: Date(),
            sourceLink: "https://example.com/saved"
        )
        
        let unsavedNewsItem = NewsItem(
            title: "Unsaved News",
            imageUrl: nil,
            imageData: nil,
            sourceName: "Test Source",
            datePublished: Date(),
            sourceLink: "https://example.com/unsaved"
        )
        
        // Mock saved items
        cacheManager.saveNewsItem(savedNewsItem)
        
        // When
        let isSaved = cacheManager.isNewsItemSaved(savedNewsItem)
        let isNotSaved = cacheManager.isNewsItemSaved(unsavedNewsItem)
        
        // Then
        XCTAssertTrue(isSaved, "Saved news item should return true for isNewsItemSaved.")
        XCTAssertFalse(isNotSaved, "Unsaved news item should return false for isNewsItemSaved.")
    }
}
