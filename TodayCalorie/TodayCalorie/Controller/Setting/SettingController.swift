//
//  SettingController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/24/24.
//

import UIKit

class SettingController: UIViewController {
    
    // MARK: - Propertie
    
    let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .fontGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 이름"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.fontGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.setTitleColor(.caution, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    let versionInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "버전 정보"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "v1.0.0"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleLogout() {
            do {
                try AuthService.shared.signOut()
                print("DEBUG: User logged out")
                // Logout and navigate to LoginController
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let window = windowScene.windows.first
                let loginController = LoginController()
                window?.rootViewController = loginController
                window?.makeKeyAndVisible()
            } catch {
                print("DEBUG: Failed to log out: \(error.localizedDescription)")
            }
        }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(settingLabel)
        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(divider)
        view.addSubview(versionInformationLabel)
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            settingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            divider.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            versionInformationLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            versionInformationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            versionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
    
}
