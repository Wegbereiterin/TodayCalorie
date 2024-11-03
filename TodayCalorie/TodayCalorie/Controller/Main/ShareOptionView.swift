//
//  ShareOptionView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

protocol ShareOptionViewDelegate: AnyObject {
    func shareOptionView(_ view: ShareOptionView, didChangeShareStatus isSharing: Bool)
}

class ShareOptionView: UIView {
    // MARK: - Properties
    weak var delegate: ShareOptionViewDelegate?
    
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
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
        addSubview(stackView)
        
        stackView.addArrangedSubview(shareLabel)
        stackView.addArrangedSubview(shareSwitch)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func shareSwitchChanged(_ sender: UISwitch) {
        delegate?.shareOptionView(self, didChangeShareStatus: sender.isOn)
    }
    
    // MARK: - Public Methods
    func getShareStatus() -> Bool {
        return shareSwitch.isOn
    }
    
    func setShareStatus(_ isSharing: Bool) {
        shareSwitch.setOn(isSharing, animated: true)
    }
}
