//
//  News_feedUITests.swift
//  News feedUITests
//
//  Created by Ivan Solohub on 10.12.2024.
//

import XCTest

final class News_feedUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        super.tearDown()
    }
    
    func testTimelineVCObjectsExists() {
        let titleLabel = app.staticTexts["MainTitleLabel"]
        let separateLine = app.otherElements["SeparateLine"]
        let tableView = app.tables["TimelineTableView"]
        
        XCTAssertTrue(titleLabel.exists)
        XCTAssertTrue(separateLine.exists)
        XCTAssertTrue(tableView.exists)
    }
    
    func testSearchingNewsVCObjectsExists() {
        let tabBar = app.tabBars["MainTabBar"]
        let searchingNewsTab = tabBar.buttons["SearchingNewsTabBarItem"]
        let titleLabel = app.staticTexts["TitleLabel"]
        let searchTF = app.textFields["SearchTF"]
        
        searchingNewsTab.tap()
        
        XCTAssertTrue(titleLabel.exists)
        XCTAssertTrue(searchTF.exists)
    }
    
    func testNotificationsVCObjectsExists() {
        let tabBar = app.tabBars["MainTabBar"]
        let notificationsTab = tabBar.buttons["NotificationsTabBarItem"]
        let mockLabel = app.staticTexts["MockLabel"]
        
        notificationsTab.tap()
        
        XCTAssertTrue(mockLabel.exists)
    }
    
    func testSavedNewsVCObjectsExists() {
        let tabBar = app.tabBars["MainTabBar"]
        let savedNewsItemsTab = tabBar.buttons["SavedNewsItemsTabBarItem"]
        let titleLabel = app.staticTexts["SaveNewsItemsVCTitleLabel"]
        let savedItemsTableView = app.tables["SaveNewsItemsVCTableView"]
        
        savedNewsItemsTab.tap()
        
        XCTAssertTrue(titleLabel.exists)
        XCTAssertTrue(savedItemsTableView.exists)
    }
    
    func testTableViewItemOpensWebViewController() {
        let tableView = app.tables["TimelineTableView"]
        let firstCell = tableView.cells.element(boundBy: 0)
        let webView = app.webViews["WebView"]
        let backButton = app.buttons["BackButtonArrow"]
        let saveButton = app.buttons["SaveButton"]
        
        firstCell.tap()
        sleep(7)
        
        XCTAssertTrue(webView.exists)
        XCTAssertTrue(backButton.exists)
        XCTAssertTrue(saveButton.exists)
    }
    
    func testNewsItemsSaving() {
        let tableView = app.tables["TimelineTableView"]
        let firstCell = tableView.cells.element(boundBy: 0)
        let backButton = app.buttons["BackButtonArrow"]
        let saveButton = app.buttons["SaveButton"]
        let tabBar = app.tabBars["MainTabBar"]
        let savedNewsItemsTab = tabBar.buttons["SavedNewsItemsTabBarItem"]
        let savedItemsTableView = app.tables["SaveNewsItemsVCTableView"]
        
        firstCell.tap()
        sleep(7)
        saveButton.tap()
        backButton.tap()
        savedNewsItemsTab.tap()
        
        XCTAssertGreaterThan(savedItemsTableView.cells.count, 0)
    }
}
