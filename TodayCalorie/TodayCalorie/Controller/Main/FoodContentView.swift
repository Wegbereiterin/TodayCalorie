//
//  FoodContentView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

class FoodContentView: UIView {
    // MARK: - Properties
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글 제목"
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.borderStyle = .none
        textField.inputAccessoryView = toolBarKeyboard
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.textContainerInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        view.textContainer.lineFragmentPadding = 0
        view.isScrollEnabled = true
        view.delegate = self
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
    
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(btnDoneBarTapped))
        toolbar.sizeToFit()
        toolbar.items = [flexBarButton, doneButton]
        toolbar.tintColor = .black
        return toolbar
    }()
    
    var title: String {
        get { titleTextField.text ?? "" }
        set { titleTextField.text = newValue }
    }
    
    var content: String {
        get { textView.text ?? "" }
        set {
            textView.text = newValue
            textViewPlaceholder.isHidden = !newValue.isEmpty
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleTextField)
        addSubview(textView)
        textView.addSubview(textViewPlaceholder)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            textView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 180),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textViewPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            textViewPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            textViewPlaceholder.trailingAnchor.constraint(equalTo: textView.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func btnDoneBarTapped() {
        endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension FoodContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholder.isHidden = !textView.text.isEmpty
        
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if estimatedSize.height <= 180 {
                // 최소 높이 유지
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
