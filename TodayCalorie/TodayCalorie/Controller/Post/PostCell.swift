//
//  PostCell.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/28/24.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "PostCell"
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "timer")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let foodNameLikeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let calorieTimeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        // 둥근 모서리와 테두리 설정
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        clipsToBounds = true
        
        // ContentView에 직접 추가
        contentView.addSubview(foodImageView)
        foodImageView.addSubview(userNameLabel)
        contentView.addSubview(divider)
        contentView.addSubview(foodNameLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(caloriesLabel)
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            // 음식 이미지
            foodImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            foodImageView.heightAnchor.constraint(equalTo: foodImageView.widthAnchor),
            
            // 사용자 이름
            userNameLabel.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: 16),
            
            // 구분선
            divider.topAnchor.constraint(equalTo: foodImageView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            // 음식 이름
            foodNameLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            foodNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // 좋아요
            likesLabel.centerYAnchor.constraint(equalTo: foodNameLabel.centerYAnchor),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 칼로리
            caloriesLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 8),
            caloriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // 상세 설명
            detailLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 8),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure() {
        userNameLabel.text = "사용자 이름"
        foodNameLabel.text = "음식 이름"
        likesLabel.text = "좋아요 16"
        caloriesLabel.text = "128 Kcal"
        detailLabel.text = "오늘 먹은 음식이 어쩌고 저쩌고.."
        foodImageView.image = UIImage(systemName: "photo")
    }
    
}
