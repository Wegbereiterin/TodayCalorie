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
        label.font = .systemFont(ofSize: .init(14)) // sb
        
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 섭취한 총 칼로리"
        label.font = .systemFont(ofSize: .init(18)) // sb
        
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("달력", for: .normal)
        button.setTitleColor(.blue, for: .normal) // 달력 그림
        button.backgroundColor = .systemBlue
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "754 Kcal"
        label.font = .systemFont(ofSize: .init(24)) // bold
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(addButton)
        view.addSubview(nameLabel)
        view.addSubview(todayLabel)
        view.addSubview(button)
        view.addSubview(calorieLabel)
        
        NSLayoutConstraint.activate([
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -27),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            calorieLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 10),
            calorieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            
            // 프로그레스 바 (칼로리 그래프)
            
            // divider (구분선)
            
            // 오늘 먹은 음식 label
            
            // 컬렉션 뷰
            
            ])
            
    }


}

