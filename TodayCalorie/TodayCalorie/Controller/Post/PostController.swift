//
//  PostController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/24/24.
//

import UIKit

class PostController: UIViewController {
    
    // MARK: - Propertie
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.text = "추천 게시글"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .fontGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)  // grouped 스타일로 변경
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
}

extension PostController: UITableViewDelegate, UITableViewDataSource {
    // 섹션 수를 데이터 개수만큼
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5  // 데이터 개수
    }
    
    // 각 섹션당 셀 하나
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            fatalError("The tableView could not dequeue a CalorieCell in ViewController")
        }
        
        cell.configure()
        return cell
    }
    
    // 섹션 헤더 높이로 셀 간격 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
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
