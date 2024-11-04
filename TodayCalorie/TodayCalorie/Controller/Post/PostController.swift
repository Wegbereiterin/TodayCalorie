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
        tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 100))
        
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(postLabel)
        
//        NSLayoutConstraint.activate([
//            postLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
//            postLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            
//            tableView.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 10),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//        ])
        
        NSLayoutConstraint.activate([
            postLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            postLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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

extension PostController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForVisibleCells()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForVisibleCells()
    }
    
    private func loadImagesForVisibleCells() {
        guard let visibleCells = tableView.visibleCells as? [PostCell] else { return }
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
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
