//
//  RecordDetailController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/25/24.
//

import UIKit

class RecordDetailController: UIViewController {
   
   // MARK: - Properties
   
   private let timeImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
       imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
       
       imageView.image = UIImage(systemName: "sun.max")
       imageView.tintColor = .red
       
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
   
   private let titleLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 24, weight: .bold)
       label.textColor = .black
       
       label.text = "햄버거 세트"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let foodImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       imageView.backgroundColor = .white
       imageView.layer.cornerRadius = 20
       imageView.layer.borderWidth = 1
       imageView.layer.borderColor = UIColor.lightGray.cgColor
       
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()
   
   private let calorieTitleLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14)
       label.textColor = .black
       
       label.text = "칼로리"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let detailTitleLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14)
       label.textColor = .black
       
       label.text = "설명"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let dateTitleLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14)
       label.textColor = .black
       
       label.text = "날짜 및 시간"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let calorieLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14, weight: .semibold)
       label.textColor = .black
       label.textAlignment = .right
       
       label.text = "128 Kcal"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let detailLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14, weight: .semibold)
       label.textColor = .black
       label.numberOfLines = 0
       label.textAlignment = .right
       
       label.text = "아침에 간단하게 먹어봤다\n시커먹은 치즈버거 세트"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let dateLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 14, weight: .semibold)
       label.textColor = .black
       label.textAlignment = .right
       
       label.text = "2024/10/21 17:48"
       
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   
   private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
       scrollView.translatesAutoresizingMaskIntoConstraints = false
       return scrollView
   }()
   
   private let stackView: UIStackView = {
       let stackView = UIStackView()
       stackView.axis = .vertical
       stackView.distribution = .fill
       stackView.spacing = 24
       stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
   }()
   
   private let titleStackView: UIStackView = {
       let stackView = UIStackView()
       stackView.axis = .horizontal
       stackView.spacing = 8
       stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
   }()
   
   private let calorieStackView: UIStackView = {
       let stackView = UIStackView()
       stackView.axis = .horizontal
       stackView.distribution = .equalSpacing
       stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
   }()
   
   private let dateTimeStackView: UIStackView = {
       let stackView = UIStackView()
       stackView.axis = .horizontal
       stackView.distribution = .equalSpacing
       stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
   }()
    
    private let foodListTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            label.text = "음식 목록"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let foodListStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       self.navigationController?.navigationBar.isHidden = false
       self.navigationController?.navigationBar.tintColor = .black
       configureUI()
   }
   
   // MARK: - Selectors
   
   // MARK: - Helpers
   
   func configureUI() {
       view.backgroundColor = .white
       
       titleStackView.addArrangedSubview(timeImageView)
       titleStackView.addArrangedSubview(titleLabel)
       
       calorieStackView.addArrangedSubview(calorieTitleLabel)
       calorieStackView.addArrangedSubview(calorieLabel)
       
       dateTimeStackView.addArrangedSubview(dateTitleLabel)
       dateTimeStackView.addArrangedSubview(dateLabel)
       
       stackView.addArrangedSubview(titleStackView)
       stackView.addArrangedSubview(foodImageView)
       stackView.addArrangedSubview(calorieStackView)
       stackView.addArrangedSubview(dateTimeStackView)
       stackView.addArrangedSubview(foodListTitleLabel)
       stackView.addArrangedSubview(foodListStackView)
       stackView.addArrangedSubview(detailTitleLabel)
       stackView.addArrangedSubview(detailLabel)
       
       view.addSubview(scrollView)
       scrollView.addSubview(stackView)
       
       NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
           scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
           stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
           stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
           stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
           
           foodImageView.heightAnchor.constraint(equalTo: foodImageView.widthAnchor)
       ])
   }
    
    private func createFoodItemView(foodItem: FoodItem) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = "\(foodItem.name) (\(foodItem.amount))"
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let calorieLabel = UILabel()
        calorieLabel.text = "\(foodItem.calories) Kcal"
        calorieLabel.font = .systemFont(ofSize: 14, weight: .medium)
        calorieLabel.textAlignment = .right
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(nameLabel)
        container.addSubview(calorieLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            calorieLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            calorieLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            container.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return container
    }
    
    func configure(with post: FoodPost) {
            titleLabel.text = post.title
            calorieLabel.text = "\(post.totalCalories) Kcal"
            detailLabel.text = post.description
            
            // 날짜 포맷
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            dateLabel.text = dateFormatter.string(from: post.createdAt.dateValue())
            
            // 식사 시간에 따른 이미지 설정
            switch post.mealTime {
            case "Morning":
                timeImageView.image = UIImage(named: "Morning_T")
            case "Afternoon":
                timeImageView.image = UIImage(named: "Afternoon_T")
            case "Evening":
                timeImageView.image = UIImage(named: "Evening_T")
            case "Snack":
                timeImageView.image = UIImage(named: "Snack_T")
            default:
                break
            }
            
            // 음식 목록 표시
        for foodItem in post.foodItems {
            let foodItemView = createFoodItemView(foodItem: foodItem)
            foodListStackView.addArrangedSubview(foodItemView)
        }
            
            // 이미지 설정 (URLSession 사용)
            if let imageUrlString = post.foodImages.first,
               let imageUrl = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
                    if let error = error {
                        print("DEBUG: 이미지 로드 실패: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.foodImageView.image = image
                        }
                    }
                }.resume()
            }
        }
}
