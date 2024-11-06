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
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo7")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 16)
        ])
    }
    
    //MARK: - Helpers
}
