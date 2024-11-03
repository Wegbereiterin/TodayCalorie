//
//  addButtonView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

protocol AddButtonViewDelegate: AnyObject {
    func addButtonViewDidTapAdd(_ view: AddButtonView)
}

class AddButtonView: UIView {
    // MARK: - Properties
    weak var delegate: AddButtonViewDelegate?
    
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
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        delegate?.addButtonViewDidTapAdd(self)
    }
}
