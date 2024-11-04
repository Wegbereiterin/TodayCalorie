//
//  ViewController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/3/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var maxCalorie = 2000
    
    private var selectedDate: Date = Date() {
        didSet {
            updateForDate(selectedDate)
        }
    }
    
    private var foodPosts: [FoodPost] = [] {
        didSet {
            tableView.reloadData()
            updateTodayCalories()
            updateEmptyState()
        }
    }
    
    private var userName: String = "사용자" {
        didSet {
            nameLabel.text = userName
        }
    }
    
    private var todayCalories: Int = 0 {
        didSet {
            calorieLabel.text = "\(todayCalories) Kcal"
        }
    }
    
    private let db = Firestore.firestore()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = userName
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 섭취한 총 칼로리"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .fontGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton()
        let calendarImage = UIImage(systemName: "calendar")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24))
        button.setImage(calendarImage, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "\(todayCalories) Kcal"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView(frame: .zero)
        progressBar.progress = 0.1
        progressBar.progressViewStyle = .bar
        progressBar.progressTintColor = .main
        progressBar.backgroundColor = .white.withAlphaComponent(0.04)
        progressBar.layer.cornerRadius = 10
        progressBar.layer.masksToBounds = true
        progressBar.layer.borderWidth = 0.1
        progressBar.layer.borderColor = UIColor.gray.cgColor
        progressBar.layer.shadowColor = UIColor.black.cgColor
        progressBar.layer.shadowOpacity = 0.1
        progressBar.transform = progressBar.transform.scaledBy(x: 1.04, y: 5.0)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CalorieCell.self, forCellReuseIdentifier: CalorieCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.allowsSelection = true
        tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 100))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var menuItems = [
        //        FloatingMenuButton.MenuItem(icon: UIImage(systemName: "pencil")!, title: "이미지없이 글작성", action: {
        //            let addFoodController = AddFoodController()
        //            let navigationController = UINavigationController(rootViewController: addFoodController)
        //            navigationController.modalPresentationStyle = .fullScreen
        //            self.present(navigationController, animated: true)
        //        }),
        FloatingMenuButton.MenuItem(icon: UIImage(systemName: "photo")!, title: "이미지선택", action: { [weak self] in
            self?.presentPhotoPicker(sourceType: UIImagePickerController.SourceType.photoLibrary)
        }),
        FloatingMenuButton.MenuItem(icon: UIImage(systemName: "camera")!, title: "사진촬영", action: { [weak self] in
            self?.presentPhotoPicker(sourceType: UIImagePickerController.SourceType.camera)
        })
    ]
    
    lazy var floatingButton: FloatingMenuButton = {
        let button = FloatingMenuButton(items: menuItems)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadUserInfo()
        loadFoodPostsForDate(selectedDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFoodPostsForDate(selectedDate)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Selectors
    
    @objc func calendarButtonTapped() {
        let calendarVC = CalendarViewController()
        calendarVC.delegate = self
        calendarVC.modalPresentationStyle = .popover
        present(calendarVC, animated: true)
    }
    
    // MARK: - API
    
    private func loadUserInfo() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userUID).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("DEBUG: 사용자 정보 로드 실패: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String {
                self?.userName = name
            }
        }
    }
    
    private func loadFoodPostsForDate(_ date: Date) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        print("DEBUG: Loading posts for date: \(date)")  // 디버깅용
        
        db.collection("food_posts")
            .whereField("userUID", isEqualTo: userUID)
            .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("createdAt", isLessThan: Timestamp(date: endOfDay))
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("DEBUG: 데이터 로드 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                print("DEBUG: Found \(documents.count) posts for date")  // 디버깅용
                
                let posts = documents.compactMap { document -> FoodPost? in
                    let data = document.data()
                    
                    guard let id = data["id"] as? String,
                          let title = data["title"] as? String,
                          let foodImages = data["foodImages"] as? [String],
                          let description = data["description"] as? String,
                          let foodItemsData = data["foodItems"] as? [[String: Any]],
                          let totalCalories = data["totalCalories"] as? Int,
                          let createdAt = data["createdAt"] as? Timestamp,
                          let mealTime = data["mealTime"] as? String,
                          let isShared = data["isShared"] as? Bool,
                          let likeCount = data["likeCount"] as? Int else {
                        return nil
                    }
                    
                    let foodItems = foodItemsData.compactMap { itemData -> FoodItem? in
                        guard let name = itemData["name"] as? String,
                              let calories = itemData["calories"] as? Int,
                              let baseCalorie = itemData["baseCalorie"] as? Int,
                              let amount = itemData["amount"] as? String,
                              let type = itemData["type"] as? String else {
                            return nil
                        }
                        return FoodItem(
                            name: name,
                            calories: calories,
                            baseCalorie: baseCalorie,
                            amount: amount,
                            type: type
                        )
                    }
                    
                    return FoodPost(
                        id: id,
                        userUID: userUID,
                        title: title,
                        foodImages: foodImages,
                        description: description,
                        foodItems: foodItems,
                        totalCalories: totalCalories,
                        createdAt: createdAt,
                        mealTime: mealTime,
                        isShared: isShared,
                        likeCount: likeCount
                    )
                }
                
                DispatchQueue.main.async {
                    self?.foodPosts = posts  // foodPosts 업데이트
                    print("DEBUG: Updated foodPosts with \(posts.count) items")  // 디버깅용
                }
            }
    }
    
    // MARK: - Helpers
    
    private func updateProgressColor() {
        switch progressBar.progress {
        case 0.0..<0.33:
            progressBar.progressTintColor = .main  // 예시 색상
        case 0.33..<0.66:
            progressBar.progressTintColor = .green
        case 0.66..<1.0:
            progressBar.progressTintColor = .orange
        default:
            progressBar.progressTintColor = .red
        }
    }
    
    private func updateTodayCalories() {
        todayCalories = foodPosts.reduce(0) { $0 + $1.totalCalories }
        progressBar.progress = Float(todayCalories) / 2000.0  // 목표 칼로리 2000
        updateProgressColor()  // 프로그레스 바 색상 업데이트
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(nameLabel)
        view.addSubview(todayLabel)
        view.addSubview(calendarButton)
        view.addSubview(calorieLabel)
        view.addSubview(progressBar)
        view.addSubview(divider)
        view.addSubview(tableView)
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            todayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            calendarButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            calendarButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            calorieLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 10),
            calorieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            progressBar.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 16),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            divider.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            divider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 2),
            
            tableView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            floatingButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
    }
    
    private func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    private func updateForDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        if Calendar.current.isDateInToday(date) {
            todayLabel.text = "오늘 섭취한 총 칼로리"
        } else {
            todayLabel.text = "\(dateFormatter.string(from: date)) 섭취한 총 칼로리"
        }
        
        loadFoodPostsForDate(date)
    }
    
    private func updateEmptyState() {
        if foodPosts.isEmpty {
            let emptyImageView = UIImageView(image: UIImage(systemName: "text.page.slash.rtl"))
            emptyImageView.tintColor = .lightGray
            emptyImageView.contentMode = .scaleAspectFit
            emptyImageView.translatesAutoresizingMaskIntoConstraints = false

            let emptyLabel = UILabel()
            emptyLabel.text = "기록이 없습니다"
            emptyLabel.font = .systemFont(ofSize: 18, weight: .medium)
            emptyLabel.textColor = .lightGray
            emptyLabel.textAlignment = .center

            let stackView = UIStackView(arrangedSubviews: [emptyImageView, emptyLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false

            tableView.backgroundView = stackView

            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -100),
                emptyImageView.widthAnchor.constraint(equalToConstant: 50),
                emptyImageView.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블뷰 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodPosts.count
    }
    
    // 테이블뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalorieCell.identifier, for: indexPath) as? CalorieCell else {
            fatalError("The tableView could not dequeue a CalorieCell in ViewController")
        }
        
        let post = foodPosts[indexPath.row]
        
        // 기본 데이터로 먼저 구성
        cell.configure(with: post, image: UIImage(named: "placeholder_image"))
        
        if let imageUrlString = post.foodImages.first,
           let imageUrl = URL(string: imageUrlString) {
            
            // 캐시에서 이미지 확인
            if let cachedImage = ImageCache.shared.getImage(for: imageUrl) {
                cell.configure(with: post, image: cachedImage)
            } else {
                // 이미지 로드 및 캐시
                cell.imageLoadTask = URLSession.shared.dataTask(with: imageUrl) { [weak cell] data, _, error in
                    if let error = error {
                        print("DEBUG: 이미지 로드 실패: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        // 이미지를 캐시에 저장
                        ImageCache.shared.setImage(image, for: imageUrl)
                        
                        DispatchQueue.main.async {
                            // 셀이 아직 화면에 표시되어 있는지 확인
                            if let cell = cell, let indexPathNow = tableView.indexPath(for: cell),
                               indexPathNow == indexPath {
                                cell.configure(with: post, image: image)
                            }
                        }
                    }
                }
                cell.imageLoadTask?.resume()
            }
        }
        
        return cell
    }
    
    // 삭제 기능 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = foodPosts[indexPath.row]
            
            // Firebase에서 게시글 삭제
            let db = Firestore.firestore()
            
            // food_posts 컬렉션에서 삭제
            db.collection("food_posts").document(post.id).delete { [weak self] error in
                if let error = error {
                    print("DEBUG: Firestore에서 게시글 삭제 실패: \(error.localizedDescription)")
                    return
                }
                
                print("DEBUG: Firestore에서 게시글 삭제 성공")
                
                // posts 컬렉션에서도 삭제
                db.collection("posts").document(post.id).delete { error in
                    if let error = error {
                        print("DEBUG: posts 컬렉션에서 게시글 삭제 실패: \(error.localizedDescription)")
                    } else {
                        print("DEBUG: posts 컬렉션에서 게시글 삭제 성공")
                    }
                    
                    // 로컬 데이터 배열에서 삭제
                    DispatchQueue.main.async { [weak self] in
                        // 데이터 소스에서 삭제
                        self?.foodPosts.remove(at: indexPath.row)
                        
                        // 테이블뷰 전체를 리로드하여 상태를 동기화
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // 테이블뷰 행 선택 시 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = foodPosts[indexPath.row]
        let detailVC = RecordDetailController()
        detailVC.configure(with: post)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}




// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            let addFoodController = AddFoodController()
            addFoodController.processSelectedImage(image)
            let navigationController = UINavigationController(rootViewController: addFoodController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
}

extension ViewController: DateSelectionDelegate {
   func didSelectDate(_ date: Date) {
       selectedDate = date
   }
}

// MARK: - Scroll

extension ViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForVisibleCells()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForVisibleCells()
    }
    
    private func loadImagesForVisibleCells() {
        guard let visibleCells = tableView.visibleCells as? [CalorieCell] else { return }
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let post = foodPosts[indexPath.row]
                if let imageUrlString = post.foodImages.first,
                   let imageUrl = URL(string: imageUrlString) {
                    // 이미지가 캐시에 있는 경우에만 즉시 로드
                    if let cachedImage = ImageCache.shared.getImage(for: imageUrl) {
                        cell.configure(with: post, image: cachedImage)
                    }
                }
            }
        }
    }
}

