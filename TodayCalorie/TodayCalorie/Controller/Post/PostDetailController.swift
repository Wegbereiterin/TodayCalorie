//
//  PostDetailController.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/4/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostDetailController: UIViewController {
    
    // MARK: - Properties
    
    private let db = Firestore.firestore()
    private var post: FoodPost?
    private var originalCommentContainerBottomConstraint: NSLayoutConstraint?
    
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
        imageView.contentMode = .scaleAspectFit
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
        label.textAlignment = .left
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
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "댓글"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private let commentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let commentInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        // 그림자 효과 추가
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요"
        textField.font = .systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        setupKeyboardObservers()
        configureUI()
        setupDoubleTapGesture()
        setupCommentActions()
        loadComments()
        setupKeyboardHandling(for: scrollView)  // scrollView 전달
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
    
    @objc private func handleAddComment() {
        guard let content = commentTextField.text, !content.isEmpty,
              let userUID = Auth.auth().currentUser?.uid,
              let postID = post?.id else { return }
        
        let commentID = UUID().uuidString
        let comment = Comment(
            id: commentID,
            userUID: userUID,
            content: content,
            createdAt: Timestamp()
        )
        
        // Firestore에 댓글 저장
        db.collection("posts").document(postID)
            .collection("comments").document(commentID)
            .setData(comment.toDictionary()) { [weak self] error in
                if let error = error {
                    print("DEBUG: 댓글 저장 실패: \(error.localizedDescription)")
                    return
                }
                
                self?.commentTextField.text = ""
                self?.loadComments()
            }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // 키보드 높이만큼 댓글 입력창을 위로 이동
        originalCommentContainerBottomConstraint?.constant = -keyboardFrame.height
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // 댓글 입력창을 원래 위치로
        originalCommentContainerBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
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
        
        stackView.addArrangedSubview(commentLabel)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(commentsStackView)
        
        view.addSubview(commentInputContainer)
        commentInputContainer.addSubview(commentTextField)
        commentInputContainer.addSubview(commentButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        let bottomConstraint = commentInputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        originalCommentContainerBottomConstraint = bottomConstraint
        
        NSLayoutConstraint.activate([
            // 스크롤뷰 제약조건
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // 중요: 스크롤뷰 bottom을 commentInputContainer의 top에 연결
            scrollView.bottomAnchor.constraint(equalTo: commentInputContainer.topAnchor),
            
            // 스택뷰 제약조건
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            // 댓글 입력 컨테이너 제약조건
            commentInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentInputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentInputContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // 텍스트필드 제약조건
            commentTextField.leadingAnchor.constraint(equalTo: commentInputContainer.leadingAnchor, constant: 16),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputContainer.centerYAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -8),
            
            // 버튼 제약조건
            commentButton.trailingAnchor.constraint(equalTo: commentInputContainer.trailingAnchor, constant: -16),
            commentButton.centerYAnchor.constraint(equalTo: commentInputContainer.centerYAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 60),
            
            bottomConstraint
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
    }
    
    private var comments: [Comment] = [] {
        didSet {
            updateCommentsUI()
        }
    }
    
    private func setupCommentActions() {
        commentButton.addTarget(self, action: #selector(handleAddComment), for: .touchUpInside)
    }
    
    private func loadComments() {
        guard let postID = post?.id else { return }
        
        db.collection("posts").document(postID)
            .collection("comments")
            .order(by: "createdAt", descending: false)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("DEBUG: 댓글 로드 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self?.comments = documents.compactMap { document -> Comment? in
                    try? document.data(as: Comment.self)
                }
            }
    }
    
    private func createCommentView(for comment: Comment) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLabel = UILabel()
        contentLabel.font = .systemFont(ofSize: 12)
        contentLabel.numberOfLines = 0
        contentLabel.text = comment.content
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 사용자 이름 가져오기
        db.collection("users").document(comment.userUID).getDocument { snapshot, _ in
            if let name = snapshot?.data()?["name"] as? String {
                nameLabel.text = name
            }
        }
        
        container.addSubview(nameLabel)
        container.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func updateCommentsUI() {
        // 기존 댓글 뷰 제거
        commentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 새로운 댓글 뷰 추가
        comments.forEach { comment in
            let commentView = createCommentView(for: comment)
            commentsStackView.addArrangedSubview(commentView)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}
