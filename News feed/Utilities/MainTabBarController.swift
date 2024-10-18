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
        
        let mainVC = TimelineVC()
        mainVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        
        let timelineVC = UIViewController()
        timelineVC.view.backgroundColor = .greyBackGroundColor
        timelineVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .greyBackGroundColor
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bell"), tag: 2)

        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .greyBackGroundColor
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bookmark"), tag: 3)
        
        viewControllers = [mainVC, timelineVC, settingsVC, profileVC]
    }

    private func addTopBorderToTabBar() {
        let lineView = UIView(frame: CGRect(x: 0, y: -10, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = .lightGreyColor
        tabBar.addSubview(lineView)
    }
}
