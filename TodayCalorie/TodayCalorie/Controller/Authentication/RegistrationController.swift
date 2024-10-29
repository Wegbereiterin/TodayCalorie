//
//  RegistrationController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/27/24.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let registTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .placeholderText
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .placeholderText
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .placeholderText
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .main
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        
        button.addTarget(self, action: #selector(registrationTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setNav()
        setKeyboard()
    }
    
    // MARK: - Selectors
    
    @objc func registrationTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            // 테두리 색 바꾸기
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            // 테두리 색 바꾸기
            
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            // 테두리 색 바꾸기
            
            return
        }
        
        Task {
            do {
                let user = try await AuthService.shared.createUser(withEmail: email, password: password, name: name)
                
                await MainActor.run {
                    dismiss(animated: true)
                }
            } catch {
                await MainActor.run {
                    print("DEBUG: 회원가입 실패 \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(registTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nameTextField)
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            registTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            registTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            emailTextField.topAnchor.constraint(equalTo: registTitleLabel.bottomAnchor, constant: 86),
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            registerButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            registerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            registerButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 57)
            
            
            ])
    }
    
    func setNav() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    func setKeyboard() {
        addKeyboardToolbar(to: emailTextField)
        addKeyboardToolbar(to: passwordTextField)
        addKeyboardToolbar(to: nameTextField)
    }
    
}
