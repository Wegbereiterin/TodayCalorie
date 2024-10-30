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
    
    let foodName: String = ""
    let calorie: Int = 0
    let detail: String = ""
    let image: UIImage? = nil
    let timeToEat: String = ""
    
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
    
    public func configure() {
        self.foodNameLabel.text = "Apple"
        self.calorieLabel.text = "95 Kcal"
        self.detailLabel.text = "오늘 오전에 먹은 사과 1개"
//        self.imageView?.image = UIImage(named: "placeholder")
        self.foodImageView.image = UIImage(named: "Apple_Sample")
        self.timeImage.image = UIImage(named: "Morning_T")
    }
    
//    public func configure(with model: Food) {
//        self.foodNameLabel.text = model.foodName
//        self.calorieLabel.text = "\(model.calories) Kcal"
//        self.detailLabel.text = model.detail
////        self.imageView.image = model.image
//    }
    
}
