//
//  SettingController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/24/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingController: UIViewController {
    
    // MARK: - Propertie
    
    private let db = Firestore.firestore()
    weak var viewController: ViewController?
    
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
    
    let divider1: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    let divider2: UIView = {
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
    
    let maxCalorieLabel: UILabel = {
        let label = UILabel()
        label.text = "일일 평균 칼로리 기준"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let manButton: UIButton = {
        let button = UIButton()
        button.setTitle("남", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapManButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let womanButton: UIButton = {
        let button = UIButton()
        button.setTitle("여", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapWomanButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        loadUserInfo()
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
    
    @objc func didTapManButton() {
            viewController?.maxCalorie = 2000
            updateButtonUI(selectedButton: manButton, deselectedButton: womanButton)
        }
        
        @objc func didTapWomanButton() {
            viewController?.maxCalorie = 1600
            updateButtonUI(selectedButton: womanButton, deselectedButton: manButton)
        }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(settingLabel)
        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(divider1)
        view.addSubview(versionInformationLabel)
        view.addSubview(versionLabel)
        view.addSubview(divider2)
        view.addSubview(maxCalorieLabel)
        view.addSubview(manButton)
        view.addSubview(womanButton)
        
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            settingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            divider1.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 16),
            divider1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            divider1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            versionInformationLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 16),
            versionInformationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            versionLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 16),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            divider2.topAnchor.constraint(equalTo: versionInformationLabel.bottomAnchor, constant: 16),
            divider2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            divider2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            maxCalorieLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 28),
            maxCalorieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            manButton.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 16),
            manButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            manButton.widthAnchor.constraint(equalToConstant: 60),
                        manButton.heightAnchor.constraint(equalToConstant: 40),
            
            womanButton.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 16),
            womanButton.trailingAnchor.constraint(equalTo: manButton.leadingAnchor, constant: -8),
            womanButton.widthAnchor.constraint(equalToConstant: 60),
                        womanButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        
        updateButtonUI(selectedButton: manButton, deselectedButton: womanButton)
    }
    
    private func loadUserInfo() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userUID).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("DEBUG: 사용자 정보 로드 실패: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String {
                self?.userNameLabel.text = name
            }
        }
    }
    
    private func updateButtonUI(selectedButton: UIButton, deselectedButton: UIButton) {
            selectedButton.backgroundColor = selectedButton.titleColor(for: .normal)?.withAlphaComponent(0.1)
            deselectedButton.backgroundColor = .clear
        }
}
