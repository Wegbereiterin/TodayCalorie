//
//  MainTabController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/22/24.
//

import UIKit

class MainTabController: UITabBarController, UINavigationControllerDelegate {
    
    // MARK: - Propertie
    
    private let customTabBar = CustomTabBar()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomTabBar()
        setupViewControllers()
    }
    
    // 네비게이션바 없애기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func setupCustomTabBar() {
        // 기본 탭바 숨기기
        tabBar.isHidden = true
        
        // 커스텀 탭바 추가
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            customTabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // 커스텀 탭바 버튼에 액션 추가
        customTabBar.onButtonTapped = { [weak self] index in
            self?.selectedIndex = index
            
        }
    }
    
    private func setupViewControllers() {
        // 각 탭에 해당하는 뷰 컨트롤러 설정
        let homeVC = UINavigationController(rootViewController: ViewController())
        
        let postVC = UINavigationController(rootViewController: PostController())
        
        let settingVC = UINavigationController(rootViewController: SettingController())
        
        homeVC.delegate = self
        postVC.delegate = self
        settingVC.delegate = self
        
        viewControllers = [homeVC, postVC, settingVC]
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if navigationController.viewControllers.count > 1 {
                customTabBar.isHidden = true
            } else {
                customTabBar.isHidden = false
            }
        }
}
