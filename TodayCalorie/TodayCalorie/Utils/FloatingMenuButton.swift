//
//  FloatingMenu.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/25/24.
//

import UIKit

class FloatingMenuButton: UIButton {
    
    // MARK: - Properties
    
    private let menuItems: [MenuItem]
    private var isMenuVisible = false
    private var menuButtons: [UIButton] = []
    private let menuBackground = UIView()
    
    struct MenuItem {
        let icon: UIImage
        let title: String
        let action: () -> Void
    }
    
    // MARK: - Lifecycle
    
    init(items: [MenuItem]) {
        self.menuItems = items
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func buttonTapped() {
        isMenuVisible ? hideMenu() : showMenu()
    }
    
    @objc private func menuItemTapped(_ sender: UIButton) {
        if let index = menuButtons.firstIndex(of: sender) {
            menuItems[index].action()
        }
        hideMenu()
    }
    
    @objc private func backgroundTapped() {
        hideMenu()
    }
    
    // MARK: - Helpers
    
    private func configureButton() {
        let plusImage = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25))
        setImage(plusImage, for: .normal)
        
        tintColor = .black
        backgroundColor = .main
        
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 60),
            heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
//        menuBackground.backgroundColor = .black.withAlphaComponent(0.5)
//        menuBackground.alpha = 0
    }
    
    private func createMenuItemButton(item: MenuItem) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        
        let imageView = UIImageView(image: item.icon)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        
        let label = UILabel()
        label.text = item.title
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        button.addTarget(self, action: #selector(menuItemTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func showMenu() {
        guard let parentView = superview else { return }
        isMenuVisible = true
        
        menuBackground.frame = parentView.bounds
        parentView.insertSubview(menuBackground, belowSubview: self)
        
        let buttonSize: CGFloat = 50
        let spacing: CGFloat = 10
        let menuWidth: CGFloat = 200
        
        menuItems.enumerated().forEach { index, item in
            let button = createMenuItemButton(item: item)
            let containerView = UIView()
            
            parentView.addSubview(containerView)
            containerView.addSubview(button)
            
            containerView.frame = CGRect(
                x: parentView.bounds.width - menuWidth - 20,
                y: frame.minY - CGFloat(index + 1) * (buttonSize + spacing),
                width: menuWidth,
                height: buttonSize
            )
            
            button.frame = containerView.bounds
            menuButtons.append(button)
            
            containerView.alpha = 0
            containerView.transform = CGAffineTransform(translationX: 20, y: 0)
            
            UIView.animate(
                withDuration: 0.1,
                delay: Double(index) * 0.1,
                options: .curveEaseOut,
                animations: {
                    containerView.alpha = 1
                    containerView.transform = .identity
                }
            )
        }
        
        UIView.animate(withDuration: 0.1) {
//            self.menuBackground.alpha = 1
            self.transform = CGAffineTransform(rotationAngle: .pi/4)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        menuBackground.addGestureRecognizer(tapGesture)
    }
    
    private func hideMenu() {
        isMenuVisible = false
        
        menuButtons.enumerated().forEach { index, button in
            guard let containerView = button.superview else { return }
            
            UIView.animate(
                withDuration: 0.1,
                delay: Double(menuButtons.count - index - 1) * 0.1,
                options: .curveEaseIn,
                animations: {
                    containerView.alpha = 0
                    containerView.transform = CGAffineTransform(translationX: 20, y: 0)
                },
                completion: { _ in
                    containerView.removeFromSuperview()
                }
            )
        }

        UIView.animate(withDuration: 0.1) {
//            self.menuBackground.alpha = 0
            self.transform = .identity
        } completion: { _ in
            self.menuBackground.removeFromSuperview()
            self.menuButtons.removeAll()
        }
    }
}
