//
//  directAddFood.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

protocol DirectAddFoodDelegate: AnyObject {
    //    func didAddNewFood(name: String, calorie: Int)
    func didAddNewFood(name: String, calorie: Int)
}

class directAddFood: UIViewController {
    
    weak var delegate: DirectAddFoodDelegate?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "무엇을 드셨나요?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var foodNameLabel: UILabel = {
        let label = UILabel()
        label.text = "음식 이름"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var foodNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "음식 이름..."
        textField.inputAccessoryView = toolBarKeyboard
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "먹은 양입력"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var calorieTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "칼로리 입력..."
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBarKeyboard
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var kcalText: UILabel = {
        let label = UILabel()
        label.text = "Kcal"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("음식 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "음식 직접 추가"
        configureUI()
    }
    
    @objc private func addButtonTapped() {
        guard let foodName = foodNameTextField.text, !foodName.isEmpty,
              let calorieText = calorieTextField.text,
              let calorie = Int(calorieText) else {
            // 에러 처리
            return
        }
        
        delegate?.didAddNewFood(name: foodName, calorie: calorie)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func btnDoneBarTapped() {
        view.endEditing(true)
    }
    
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(btnDoneBarTapped))
        toolbar.sizeToFit()
        toolbar.items = [flexBarButton, doneButton]
        toolbar.tintColor = .black
        return toolbar
    }()
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(foodNameLabel)
        view.addSubview(foodNameTextField)
        view.addSubview(calorieLabel)
        view.addSubview(calorieTextField)
        view.addSubview(kcalText)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            foodNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 31),
            foodNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            foodNameTextField.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 16),
            foodNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            calorieLabel.topAnchor.constraint(equalTo: foodNameTextField.bottomAnchor, constant: 16),
            calorieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            calorieTextField.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 16),
            calorieTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            kcalText.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 16),
            kcalText.leftAnchor.constraint(equalTo: calorieLabel.rightAnchor, constant: 16),
            kcalText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
