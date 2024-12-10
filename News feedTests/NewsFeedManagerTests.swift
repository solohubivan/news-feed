//
//  News_feedTests.swift
//  News feedTests
//
//  Created by Ivan Solohub on 09.12.2024.
//

import XCTest
@testable import News_feed

final class NewsFeedManagerTests: XCTestCase {
    
    var newsFeedManager: NewsFeedManager?
    
    override func setUp() {
        super.setUp()
        newsFeedManager = NewsFeedManager()
    }
    
    func testFetchInitialNewsPopulatesCombinedNewsItems() {
        // Given
        guard let newsFeedManager = newsFeedManager else { return }
        let expectation = self.expectation(description: "Fetch Initial News")
            
        // When
        newsFeedManager.fetchInitialNews {
            let combinedNewsItems = newsFeedManager.getCombinedNewsItems()
            // Then
            XCTAssertFalse(combinedNewsItems.isEmpty, "Combined news items should not be empty after fetching initial news.")
            expectation.fulfill()
        }
            
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchMoreNewsAddsOnlyUniqueNews() {
        // Given
        guard let newsFeedManager = newsFeedManager else { return }
        let initialNewsItem = NewsItem(
            title: "Initial News",
            imageUrl: nil,
            imageData: nil,
            sourceName: "Source A",
            datePublished: Date(),
            sourceLink: "https://example.com"
        )
        let duplicateNewsItem = initialNewsItem
        
        // Inject mock data into the manager
        newsFeedManager.injectInitialData(
            combined: [initialNewsItem],
            prepared: [duplicateNewsItem]
        )
        
        let expectation = self.expectation(description: "Fetch Only Unique News")
        // When
        newsFeedManager.fetchMoreNews {
            // Then
            let combinedNewsItems = newsFeedManager.getCombinedNewsItems()

            XCTAssertEqual(combinedNewsItems.count, 1, "Combined news items should not include duplicates.")
            XCTAssertTrue(combinedNewsItems.contains(where: { $0.title == "Initial News" }), "Combined news should contain the initial news item.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMoreNewsAddsNewNewsToCombinedItems() {
        // Given
        guard let newsFeedManager = newsFeedManager else { return }
        let initialNewsItem = NewsItem(
            title: "Initial News",
            imageUrl: nil,
            imageData: nil,
            sourceName: "Source A",
            datePublished: Date(),
            sourceLink: "https://example.com"
        )
        let newNewsItem = NewsItem(
            title: "New Unique News",
            imageUrl: nil,
            imageData: nil,
            sourceName: "Source B",
            datePublished: Date().addingTimeInterval(-3600),
            sourceLink: "https://example.com/new"
        )

        // Inject mock data into the manager
        newsFeedManager.injectInitialData(
            combined: [initialNewsItem],
            prepared: [newNewsItem]
        )
        
        let expectation = self.expectation(description: "Fetch Adds New News")

        // When
        newsFeedManager.fetchMoreNews {
            // Then
            let combinedNewsItems = newsFeedManager.getCombinedNewsItems()

            XCTAssertEqual(combinedNewsItems.count, 2, "Combined news items should include the initial and new items.")
            XCTAssertTrue(combinedNewsItems.contains(where: { $0.title == "Initial News" }), "Combined news should contain the initial news item.")
            XCTAssertTrue(combinedNewsItems.contains(where: { $0.title == "New Unique News" }), "Combined news should contain the new unique news item.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
