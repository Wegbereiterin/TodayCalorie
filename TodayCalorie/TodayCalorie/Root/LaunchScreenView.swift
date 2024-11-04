//
//  LaunchScreenView.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/4/24.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    
    //MARK: - Properties
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Today Calorie"
        label.font = .systemFont(ofSize: .init(40), weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Selectors
    
    private func setupUI() {
        view.backgroundColor = .main
        view.addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - Helpers
}
