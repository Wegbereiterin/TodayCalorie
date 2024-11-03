//
//  PostDetailController.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/4/24.
//

import UIKit
import FirebaseFirestore

class PostDetailController: UIViewController {
    
    // MARK: - Properties
    
    private let db = Firestore.firestore()
    private var post: FoodPost?
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
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
        imageView.isUserInteractionEnabled = true
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
    
    private let foodListTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "음식 목록"
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .right
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
    
    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
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
    
    private let foodListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDoubleTapGesture()
    }
    
    // MARK: - Actions
    
    private func setupDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        foodImageView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func handleDoubleTap() {
        guard let post = post else { return }
        
        let postRef = db.collection("posts").document(post.id)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let oldLikeCount = postDocument.data()?["likeCount"] as? Int else {
                return nil
            }
            
            transaction.updateData(["likeCount": oldLikeCount + 1], forDocument: postRef)
            return oldLikeCount + 1
            
        }) { [weak self] (newLikeCount, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else if let newCount = newLikeCount as? Int {
                DispatchQueue.main.async {
                    self?.likesCountLabel.text = "좋아요 \(newCount)"
                }
            }
        }
    }
    
    // MARK: - Helpers
    
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
    
    func configureUI() {
        view.backgroundColor = .white
        
        titleStackView.addArrangedSubview(timeImageView)
        titleStackView.addArrangedSubview(titleLabel)
        
        userInfoStackView.addArrangedSubview(userNameLabel)
        userInfoStackView.addArrangedSubview(likesCountLabel)
        
        calorieStackView.addArrangedSubview(calorieTitleLabel)
        calorieStackView.addArrangedSubview(calorieLabel)
        
        dateTimeStackView.addArrangedSubview(dateTitleLabel)
        dateTimeStackView.addArrangedSubview(dateLabel)
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(userInfoStackView)
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
    
    func configure(with post: FoodPost) {
        self.post = post
        
        // 작성자 이름 가져오기
        db.collection("users").document(post.userUID).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("DEBUG: 작성자 정보 로드 실패: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String {
                DispatchQueue.main.async {
                    self?.userNameLabel.text = name
                }
            }
        }
        
        titleLabel.text = post.title
        calorieLabel.text = "\(post.totalCalories) Kcal"
        likesCountLabel.text = "좋아요 \(post.likeCount)"
        detailLabel.text = post.description
        
        // 날짜 포맷
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateLabel.text = dateFormatter.string(from: post.createdAt.dateValue())
        
        // 음식 목록 표시
        for foodItem in post.foodItems {
            let foodItemView = createFoodItemView(foodItem: foodItem)
            foodListStackView.addArrangedSubview(foodItemView)
        }
        
        // 이미지 설정
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
        
        // 식사 시간에 따른 이미지 설정
        switch post.mealTime {
        case "morning":
            timeImageView.image = UIImage(named: "Morning_T")
        case "lunch":
            timeImageView.image = UIImage(named: "Lunch_T")
        case "evening":
            timeImageView.image = UIImage(named: "Evening_T")
        case "snack":
            timeImageView.image = UIImage(named: "Snack_T")
        default:
            break
        }
    }
}
