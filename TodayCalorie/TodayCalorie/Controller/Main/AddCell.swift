//
//  AddCell.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

class AddCell: UICollectionViewCell {
    static let identifier = "AddCell"
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false  // 버튼 자체의 터치 이벤트 비활성화
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.backgroundColor = .systemGray6  // 셀 자체에 배경색 추가
        self.isUserInteractionEnabled = true  // 셀 자체의 터치 이벤트 활성화
        
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            plusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            // 터치 효과 추가
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
}
