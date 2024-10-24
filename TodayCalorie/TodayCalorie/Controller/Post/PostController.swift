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
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        view.addSubview(postLabel)
        
        NSLayoutConstraint.activate([
            postLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            postLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    
}
