//
//  CustomTabBar.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/4/24.
//

import UIKit

class CustomTabBar: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 25
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stack.layer.borderColor = UIColor.gray.cgColor
        stack.layer.borderWidth = 1
        stack.layer.shadowColor = UIColor.black.cgColor
        stack.layer.shadowOffset = .zero
        stack.layer.shadowRadius = 10
        return stack
    }()
    
    private let homeButton = createButton(systemName: "house")
    private let searchButton = createButton(systemName: "book.pages")
    private let addButton = createButton(systemName: "gearshape")
    
    private var selectedButton: UIButton?
    
    var onButtonTapped: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        // Set initial selected button
        buttonTapped(homeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        
        // Button을 감싸는 UIView 추가
        let homeButtonContainer = createButtonContainer(for: homeButton)
        let searchButtonContainer = createButtonContainer(for: searchButton)
        let addButtonContainer = createButtonContainer(for: addButton)
        
        stackView.addArrangedSubview(homeButtonContainer)
        stackView.addArrangedSubview(searchButtonContainer)
        stackView.addArrangedSubview(addButtonContainer)
        
        homeButton.tag = 0
        searchButton.tag = 1
        addButton.tag = 2
        
        [homeButton, searchButton, addButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        // Deselect the previous selected button
        if let selectedButton = selectedButton {
            selectedButton.tintColor = .label
        }
        
        // Select the new button
        sender.tintColor = .main
        
        selectedButton = sender
        
        // Trigger the callback
        onButtonTapped?(sender.tag)
    }
    
    private static func createButton(systemName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = .label
        return button
    }
    
    private func createButtonContainer(for button: UIButton) -> UIView {
        let container = UIView()
        container.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 30), // 원하는 버튼 크기
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 터치 영역 확장을 위해 추가 패딩을 줍니다.
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 50).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return container
    }
}

