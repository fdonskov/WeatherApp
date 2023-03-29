//
//  MainTabBarController.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    // MARK: - Properties
    
    func setupTabBar() {
        
        let weatherViewController = createNavController(vc: WeatherViewController(),
                                                        itemName: "Weather",
                                                        itemImage: "cloud.fill")
        
        let favotitsViewController = createNavController(vc: FavoritsViewController(),
                                                         itemName: "Favorits",
                                                         itemImage: "star.fill")
        
        weatherViewController.tabBarItem.tag = 0
        favotitsViewController.tabBarItem.tag = 1
        
        viewControllers = [weatherViewController, favotitsViewController]
    }
    
    // MARK: - Private properties
    
    private func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        
        let item = UITabBarItem(title: itemName,
                                image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 0,
                                                                                                     left: 0,
                                                                                                     bottom: 0,
                                                                                                     right: 0)),
                                tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0,
                                             vertical: 0)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        
        return navController
    }
}
