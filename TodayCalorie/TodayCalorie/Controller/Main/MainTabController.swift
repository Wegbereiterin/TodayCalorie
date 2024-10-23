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
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
}
