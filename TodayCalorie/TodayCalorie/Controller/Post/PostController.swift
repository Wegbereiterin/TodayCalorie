//
//  PostController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/24/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostController: UIViewController {
    
    // MARK: - Propertie
    
    private var posts: [FoodPost] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let db = Firestore.firestore()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.text = "추천 게시글"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .fontGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)  // grouped 스타일로 변경
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        tableView.rowHeight = 450
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        
        // 섹션 기본 여백 제거
        tableView.sectionHeaderTopPadding = 0
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadTodayFoodPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTodayFoodPosts()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(postLabel)
        
        NSLayoutConstraint.activate([
            postLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            postLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func loadTodayFoodPosts() {
        db.collection("posts")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("DEBUG: 데이터 로드 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self?.posts = documents.compactMap { document -> FoodPost? in
                    let data = document.data()
                    
                    guard let id = data["id"] as? String,
                          let userUID = data["userUID"] as? String,
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
            }
    }
}

extension PostController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            fatalError("The tableView could not dequeue a CalorieCell in ViewController")
        }
        
        let post = posts[indexPath.row]
        
        cell.configure(with: post, image: nil)
        
        if let imageUrlString = post.foodImages.first,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let error = error {
                    print("DEBUG: 이미지 로드 실패: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.configure(with: post, image: image)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let detailVC = PostDetailController()
        detailVC.configure(with: post)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // 섹션 헤더 높이로 셀 간격 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // 헤더뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    // 푸터 높이 0으로 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
