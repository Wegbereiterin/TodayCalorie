//
//  RegistrationController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/27/24.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let registTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "TodayCalorie"
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        label.textColor = .main
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
    
    private let loginButton: UIButton = {
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(registTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nameTextField)
        view.addSubview(loginButton)
        
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
            
            loginButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
            
            
            ])
    }
    
}
