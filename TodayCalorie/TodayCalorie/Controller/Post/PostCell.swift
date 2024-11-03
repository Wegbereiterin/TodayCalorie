//
//  PostCell.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/28/24.
//

import UIKit
import FirebaseFirestore

class PostCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "PostCell"
    private let db = Firestore.firestore()
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        label.backgroundColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
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
        label.font = .systemFont(ofSize: 18, weight: .medium)
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
    
    private let timeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        contentView.addSubview(titleLabel)
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
            titleLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // 좋아요
            likesLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 칼로리
            caloriesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            caloriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // 상세 설명
            foodNameLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 8),
            foodNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            foodNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 상세 설명
            detailLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 8),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    public func configure(with post: FoodPost, image: UIImage? = nil) {
        // userUID로 사용자 이름 가져오기
        db.collection("users").document(post.userUID).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("DEBUG: 작성자 정보 로드 실패: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String {
                DispatchQueue.main.async {
                    self?.userNameLabel.text = name  // 작성자의 이름으로 설정
                }
            }
        }
        
        self.titleLabel.text = post.title
        self.caloriesLabel.text = "\(post.totalCalories) Kcal"
        
        // 음식 목록 문자열 생성
        let foodDescriptions = post.foodItems.map { "\($0.name)(\($0.calories)Kcal)" }
            let fullText = foodDescriptions.joined(separator: ", ")
        
        // 최대 길이 설정 (예: 30자)
        let maxLength = 30
        let truncatedText = fullText.count > maxLength
            ? fullText.prefix(maxLength) + "..."
            : fullText
        
        self.foodNameLabel.text = truncatedText
        self.detailLabel.text = post.description
        self.likesLabel.text = "좋아요 \(post.likeCount)"
        
        if let image = image {
            self.foodImageView.image = image
        }
        
        // 식사 시간에 따른 이미지 설정
        switch post.mealTime {
        case "Morning":
            self.timeImage.image = UIImage(named: "Morning_T")
        case "Afternoon":
            self.timeImage.image = UIImage(named: "Afternoon_T")
        case "Evening":
            self.timeImage.image = UIImage(named: "Evening_T")
        case "Snack":
            self.timeImage.image = UIImage(named: "Snack_T")
        default:
            break
        }
    }
    
}
