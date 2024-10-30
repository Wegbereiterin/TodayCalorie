//
//  AddFoodController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/25/24.
//

import UIKit

class AddFoodController: UIViewController {
    
    // MARK: - Properties
    
    var detailText: String = ""
    
    var calorie: Int = 0
    var foodName: String = ""
    
    var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                imageView.image = image
            }
        }
    }
    
    private var isShare: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 식사를 하셨나요?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
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
    
    private lazy var moringButton: EatTimeButton = {
        let button = EatTimeButton()
        button.configure(type: .morning)
        button.addTarget(self, action: #selector(morningButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var lunchButton: EatTimeButton = {
        let button = EatTimeButton()
        button.configure(type: .afternoon)
        button.addTarget(self, action: #selector(lunchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dinnerButton: EatTimeButton = {
        let button = EatTimeButton()
        button.configure(type: .evening)
        button.addTarget(self, action: #selector(dinnerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var snackButton: EatTimeButton = {
        let button = EatTimeButton()
        button.configure(type: .snack)
        button.addTarget(self, action: #selector(snackButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var foodNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "음식 이름"
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.inputAccessoryView = toolBarKeyboard
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var foodCalorieTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = .systemFont(ofSize: 12, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBarKeyboard
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "Kcal"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calorieStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글에 공유"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .main
        toggle.addTarget(self, action: #selector(shareSwitchChanged), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let shareStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("추가", for: .normal)
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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let textFieldStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 100
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(btnDoneBarTapped))
        toolbar.sizeToFit()
        toolbar.items = [flexBarButton, doneButton]
        toolbar.tintColor = .black
        return toolbar
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.textContainerInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        view.textContainer.lineFragmentPadding = 0
        view.isScrollEnabled = false
        view.inputAccessoryView = toolBarKeyboard
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textViewPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "문구 추가..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        configureUI()
        setupPlaceholder()
        setKeyboard()
        setNav()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    
    @objc func morningButtonTapped() {
        moringButton.isOn = true
        lunchButton.isOn = false
        dinnerButton.isOn = false
        snackButton.isOn = false
        print("아침")
    }
    
    @objc func lunchButtonTapped() {
        moringButton.isOn = false
        lunchButton.isOn = true
        dinnerButton.isOn = false
        snackButton.isOn = false
        print("점심")
    }
    
    @objc func dinnerButtonTapped() {
        moringButton.isOn = false
        lunchButton.isOn = false
        dinnerButton.isOn = true
        snackButton.isOn = false
        print("저녁")
    }
    
    @objc func snackButtonTapped() {
        moringButton.isOn = false
        lunchButton.isOn = false
        dinnerButton.isOn = false
        snackButton.isOn = true
        print("간식")
    }
    
    @objc func btnDoneBarTapped(sender: Any) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkButtonTapped() {
        
    }
    
    @objc private func shareSwitchChanged(_ sender: UISwitch) {
        isShare.toggle()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        if imageView.image == nil {
            view.backgroundColor = .white
            
            view.addSubview(scrollView)
            view.addSubview(addButtonContainer)
            scrollView.addSubview(stack)
            addButtonContainer.addSubview(addButton)
            
            // 칼로리 입력 스택뷰 설정
            calorieStack.addArrangedSubview(foodCalorieTextField)
            calorieStack.addArrangedSubview(kcalLabel)
            
            shareStack.addArrangedSubview(shareLabel)
            shareStack.addArrangedSubview(shareSwitch)
            
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(buttonStack)
            stack.addArrangedSubview(textFieldStack)
            stack.addArrangedSubview(textView)
            stack.addArrangedSubview(shareStack)
            
            buttonStack.addArrangedSubview(moringButton)
            buttonStack.addArrangedSubview(lunchButton)
            buttonStack.addArrangedSubview(dinnerButton)
            buttonStack.addArrangedSubview(snackButton)
            
            textFieldStack.addArrangedSubview(foodNameTextField)
            textFieldStack.addArrangedSubview(calorieStack)
            
            foodCalorieTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            NSLayoutConstraint.activate([
                addButtonContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
                addButtonContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
                addButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                addButtonContainer.heightAnchor.constraint(equalToConstant: 70),
                
                addButton.topAnchor.constraint(equalTo: addButtonContainer.topAnchor, constant: 5),
                addButton.leftAnchor.constraint(equalTo: addButtonContainer.leftAnchor, constant: 16),
                addButton.rightAnchor.constraint(equalTo: addButtonContainer.rightAnchor, constant: -16),
                addButton.bottomAnchor.constraint(equalTo: addButtonContainer.bottomAnchor, constant: -5),
                
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
                scrollView.bottomAnchor.constraint(equalTo: addButtonContainer.topAnchor),
                
                stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                stack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
                stack.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
                stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
                stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
                
                shareStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                shareStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                
                textView.heightAnchor.constraint(equalToConstant: 180),
                
                buttonStack.heightAnchor.constraint(equalToConstant: 80),
                
                textFieldStack.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            [moringButton, lunchButton, dinnerButton, snackButton].forEach { button in
                button.translatesAutoresizingMaskIntoConstraints = false
            }
            
            [foodNameTextField, foodCalorieTextField].forEach { textField in
                textField.translatesAutoresizingMaskIntoConstraints = false
            }
        } else {
            
            view.backgroundColor = .white
            
            view.addSubview(scrollView)
            view.addSubview(addButtonContainer)
            scrollView.addSubview(stack)
            addButtonContainer.addSubview(addButton)
            
            // 칼로리 입력 스택뷰 설정
            calorieStack.addArrangedSubview(foodCalorieTextField)
            calorieStack.addArrangedSubview(kcalLabel)
            
            shareStack.addArrangedSubview(shareLabel)
            shareStack.addArrangedSubview(shareSwitch)
            
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(imageView)
            stack.addArrangedSubview(buttonStack)
            stack.addArrangedSubview(textFieldStack)
            stack.addArrangedSubview(textView)
            stack.addArrangedSubview(shareStack)
            
            imageView.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            
            buttonStack.addArrangedSubview(moringButton)
            buttonStack.addArrangedSubview(lunchButton)
            buttonStack.addArrangedSubview(dinnerButton)
            buttonStack.addArrangedSubview(snackButton)
            
            textFieldStack.addArrangedSubview(foodNameTextField)
            textFieldStack.addArrangedSubview(calorieStack)
            
            foodCalorieTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            NSLayoutConstraint.activate([
                addButtonContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
                addButtonContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
                addButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                addButtonContainer.heightAnchor.constraint(equalToConstant: 70),
                
                addButton.topAnchor.constraint(equalTo: addButtonContainer.topAnchor, constant: 5),
                addButton.leftAnchor.constraint(equalTo: addButtonContainer.leftAnchor, constant: 16),
                addButton.rightAnchor.constraint(equalTo: addButtonContainer.rightAnchor, constant: -16),
                addButton.bottomAnchor.constraint(equalTo: addButtonContainer.bottomAnchor, constant: -5),
                
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
                scrollView.bottomAnchor.constraint(equalTo: addButtonContainer.topAnchor),
                
                stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                stack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
                stack.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
                stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
                stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
                
                shareStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                shareStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                
                textView.heightAnchor.constraint(equalToConstant: 180),
                
                buttonStack.heightAnchor.constraint(equalToConstant: 80),
                
                textFieldStack.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            [moringButton, lunchButton, dinnerButton, snackButton].forEach { button in
                button.translatesAutoresizingMaskIntoConstraints = false
            }
            
            [foodNameTextField, foodCalorieTextField].forEach { textField in
                textField.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    public func configure(image: UIImage, foodName: String, foodCalories: Int) {
        self.imageView.image = image
        self.foodNameTextField.text = foodName
        self.foodCalorieTextField.text = String(foodCalories)
    }
    
    func setKeyboard() {
        setupKeyboardHandling(for: scrollView)
        addKeyboardToolbar(to: textView)
        addKeyboardToolbar(to: foodNameTextField)
        addKeyboardToolbar(to: foodCalorieTextField)
    }
    
    func setNav() {
        navigationController?.navigationBar.isHidden = true
    }
}

extension AddFoodController: UITextViewDelegate {
    
    func setupPlaceholder() {
        textView.addSubview(textViewPlaceholder)
        
        NSLayoutConstraint.activate([
            textViewPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            textViewPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            textViewPlaceholder.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
        
        textViewPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholder.isHidden = !textView.text.isEmpty
        detailText = textView.text
        
        let size = CGSize(width: scrollView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            if estimatedSize.height <= 180 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
