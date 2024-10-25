//
//  AddFoodController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/25/24.
//

import UIKit

class AddFoodController: UIViewController {
    
    // MARK: - Properties
    
    private var calorieInfo: [String: Int] = [:]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 식사를 하셨나요?"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .fontGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var moringButton: UIButton = {
        let button = UIButton()
        button.setTitle("아침", for: .normal)
        button.setTitleColor(.fontGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private var lunchButton: UIButton = {
        let button = UIButton()
        button.setTitle("점심", for: .normal)
        button.setTitleColor(.fontGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private var dinnerButton: UIButton = {
        let button = UIButton()
        button.setTitle("저녁", for: .normal)
        button.setTitleColor(.fontGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private var snackButton: UIButton = {
        let button = UIButton()
        button.setTitle("간식", for: .normal)
        button.setTitleColor(.fontGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    var foodNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "음식 이름"
        textField.font = .systemFont(ofSize: 14, weight: .semibold)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        
        return textField
    }()
    
    var foodCalorieTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0 Kcal"
        textField.font = .systemFont(ofSize: 12, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        
        return textField
    }()
    
    var detailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "문구 추가..."
        textField.font = .systemFont(ofSize: 14, weight: .semibold)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        
        return textField
    }()
    
    let shareLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글에 공유"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("공유", for: .normal)
        button.setTitleColor(.fontGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .main
        button.layer.cornerRadius = 15
        
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
    }
    
    
}
