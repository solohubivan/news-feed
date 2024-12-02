//
//  MainTabBarController.swift
//  News feed
//
//  Created by Ivan Solohub on 17.10.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        addTopBorderToTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .choosedObjectColor
        tabBar.unselectedItemTintColor = .lightGreyColor
        
        let timelineVC = TimelineVC()
        timelineVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: AppConstants.ImagesNames.house), tag: 0)
        
        let searchingNewsVC = SearchingNewsVC()
        searchingNewsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: AppConstants.ImagesNames.magnifyingglass), tag: 1)

        let notificationsVC = NotificationsVC()
        notificationsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: AppConstants.ImagesNames.bell), tag: 2)

        let savedNewsItemsVC = SavedNewsItemsVC()
        savedNewsItemsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: AppConstants.ImagesNames.bookmark), tag: 3)
        
        viewControllers = [timelineVC, searchingNewsVC, notificationsVC, savedNewsItemsVC]
    }

    private func addTopBorderToTabBar() {
        let lineView = UIView(frame: CGRect(x: 0, y: -10, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = .lightGreyColor
        tabBar.addSubview(lineView)
    }
}
