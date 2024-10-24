//
//  MainTabController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/22/24.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Propertie
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureViewControllers() {
        
        let viewController = ViewController()
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: viewController)
        
        let postController = PostController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "book.pages"), rootViewController: postController)
        
        let settingController = SettingController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "gearshape"), rootViewController: settingController)
        
        viewControllers = [nav1, nav2, nav3]
        
        let titleText = "TodayCalorie"
        navigationItem.title = titleText
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        // 탭바 아이템 설정
        navController.tabBarItem.image = image
        
        return navController
        
    }
}
