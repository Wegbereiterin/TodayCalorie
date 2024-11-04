//
//  CalorieCell.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/24/24.
//

import UIKit

class CalorieCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = "CalorieCell"
    
    var imageLoadTask: URLSessionDataTask?
    
    let foodName: String = ""
    let calorie: Int = 0
    let detail: String = ""
    let image: UIImage? = nil
    let timeToEat: String = ""
    let foodList: [String] = []
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calorieLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeImage: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .label
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        func setSelected(_ selected: Bool, animated: Bool) {
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        foodImageView.image = UIImage(named: "placeholder_image")
        foodNameLabel.text = nil
        calorieLabel.text = nil
        detailLabel.text = nil
        timeImage.image = nil
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
        self.contentView.addSubview(foodImageView)
        self.contentView.addSubview(foodNameLabel)
        self.contentView.addSubview(calorieLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(timeImage)
        
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            foodImageView.widthAnchor.constraint(equalToConstant: 87),
            foodImageView.heightAnchor.constraint(equalToConstant: 87),
            
            foodNameLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            foodNameLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 16),
            
            calorieLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 8),
            calorieLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 16),
            
            detailLabel.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 8),
            detailLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 16),
            
            timeImage.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            timeImage.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
            
        ])
    }
    
    public func configure(with post: FoodPost, image: UIImage? = nil) {
        self.foodNameLabel.text = post.title
        self.calorieLabel.text = "\(post.totalCalories) Kcal"
        
        // 음식 목록 문자열 생성
        let foodDescriptions = post.foodItems.map { "\($0.name)(\($0.calories)Kcal)" }
        let fullText = foodDescriptions.joined(separator: ", ")
        
        // 최대 길이 설정 (예: 30자)
        let maxLength = 30
        let truncatedText = fullText.count > maxLength
        ? fullText.prefix(maxLength) + "..."
        : fullText
        
        self.detailLabel.text = truncatedText
        
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
