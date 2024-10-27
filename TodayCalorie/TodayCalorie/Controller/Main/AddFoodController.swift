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
//        imageView.contentMode = .scaleAspectFill
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
    
    lazy var foodNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "음식 이름"
        textField.font = .systemFont(ofSize: 14, weight: .semibold)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.inputAccessoryView = toolBarKeyboard
        
        return textField
    }()
    
    lazy var foodCalorieTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0 Kcal"
        textField.font = .systemFont(ofSize: 12, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.inputAccessoryView = toolBarKeyboard
        
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("확인", for: .normal)
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
        stack.spacing = 10
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
        toolbar.tintColor = .main
        return toolbar
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.textContainerInset = UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4)
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
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    
    @objc func btnDoneBarTapped(sender: Any) {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
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
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(addButtonContainer)
        scrollView.addSubview(stack)
        addButtonContainer.addSubview(addButton)
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(buttonStack)
        stack.addArrangedSubview(textFieldStack)
        stack.addArrangedSubview(textView)
        
        imageView.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        buttonStack.addArrangedSubview(moringButton)
        buttonStack.addArrangedSubview(lunchButton)
        buttonStack.addArrangedSubview(dinnerButton)
        buttonStack.addArrangedSubview(snackButton)
        
        textFieldStack.addArrangedSubview(foodNameTextField)
        textFieldStack.addArrangedSubview(foodCalorieTextField)
        
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
            
            textView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        [moringButton, lunchButton, dinnerButton, snackButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        [foodNameTextField, foodCalorieTextField].forEach { textField in
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    public func configure(image: UIImage, foodName: String, foodCalories: Int) {
        self.imageView.image = image
        self.foodNameTextField.text = foodName
        self.foodCalorieTextField.text = String(foodCalories)
    }
    
    
}

extension AddFoodController: UITextViewDelegate {
    
    func setupPlaceholder() {
        textView.addSubview(textViewPlaceholder)
        
        textViewPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16).isActive = true
        textViewPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 8).isActive = true
        textViewPlaceholder.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8).isActive = true
        
        textViewPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholder.isHidden = !textView.text.isEmpty
        detailText = textView.text
        
        // 텍스트뷰 스크롤 없이 height 길어지게끔..
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.black.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
