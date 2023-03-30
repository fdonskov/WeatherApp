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
                                                        itemName: Resources.TabBar.weatherItemName,
                                                        itemImage: Resources.TabBar.weatherItemImage)
        
        let favoritesViewController = createNavController(vc: FavoritesViewController(),
                                                          itemName: Resources.TabBar.favoritsItemName,
                                                         itemImage: Resources.TabBar.favoritsItemImage)
        
        weatherViewController.tabBarItem.tag = Resources.TabBar.weatherTeg
        favoritesViewController.tabBarItem.tag = Resources.TabBar.favoritsTeg
        
        viewControllers = [weatherViewController, favoritesViewController]
    }
    
    // MARK: - Private properties
    
    private func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        
        let item = UITabBarItem(title: itemName,
                                image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: Resources.TabBar.standartOffSet,
                                                                                                     left: Resources.TabBar.standartOffSet,
                                                                                                     bottom: Resources.TabBar.standartOffSet,
                                                                                                     right: Resources.TabBar.standartOffSet)),
                                tag: 0)
        item.titlePositionAdjustment = .init(horizontal: Resources.TabBar.standartOffSet,
                                             vertical: Resources.TabBar.standartOffSet)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        
        return navController
    }
}
