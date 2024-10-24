//
//  ViewController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 이름"
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
        label.text = "754 Kcal"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        
        let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25))
        
        button.setImage(plusImage, for: .normal)
        button.tintColor = .black
        
        button.backgroundColor = .main

        button.layer.cornerRadius = 30
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return button
    }()
    
    // Progress Bar
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView(frame: .zero)
        progressBar.progress = 0.7
        progressBar.progressViewStyle = .bar
        progressBar.progressTintColor = .main
        progressBar.backgroundColor = .white.withAlphaComponent(0.04)
        
        progressBar.layer.cornerRadius = 10
        progressBar.layer.masksToBounds = true
        
        progressBar.layer.borderWidth = 0.1
        progressBar.layer.borderColor = UIColor.gray.cgColor
        
        // 그림자 추가 예정
        progressBar.layer.shadowColor = UIColor.black.cgColor
        progressBar.layer.shadowOpacity = 0.1
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1.04, y: 5.0)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    let divider: UIView = {
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
        
        view.addSubview(nameLabel)
        view.addSubview(todayLabel)
        view.addSubview(calendarButton)
        view.addSubview(calorieLabel)
        view.addSubview(progressBar)
        view.addSubview(divider)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            calendarButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            calorieLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 10),
            calorieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // 프로그레스 바 (칼로리 그래프)
            progressBar.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 16),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            // divider (구분선)
            divider.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            divider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 2),
            
            
            // 오늘 먹은 음식 label
            
            // 컬렉션 뷰
            tableView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -27)
            
            ])
            
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalorieCell.identifier, for: indexPath) as? CalorieCell else {
                    fatalError("The tableView could not dequeue a CalorieCell in ViewController")
                }
        
//        let calorie = Calorie.allCases[indexPath.row]
        cell.configure()
        
        return cell
    }
}

