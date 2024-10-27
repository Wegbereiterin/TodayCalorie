//
//  EatTimeButton.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/27/24.
//

import UIKit

class EatTimeButton: UIButton {
    
    // MARK: - Properties
    
    private var type: eatType?
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var isOn: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(corder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        
        addSubview(timeImageView)
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            
            timeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timeImageView.widthAnchor.constraint(equalToConstant: 32),
            timeImageView.heightAnchor.constraint(equalToConstant: 32),
            
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: 4),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            
        ])
    }
    
    func configure(type: eatType) {
        self.type = type
        timeLabel.text = type.title
        updateUI()
    }
    
    func updateUI() {
        guard let type = type else { return }
        let imageName = isOn ? "\(type.rawValue)_T" : "\(type.rawValue)_F"
        timeImageView.image = UIImage(named: imageName)
        
        if isOn {
            timeLabel.textColor = .black
        } else {
            timeLabel.textColor = .gray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum eatType: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case snack = "Snack"
    
    var title: String {
        switch self {
        case .morning: return "아침"
        case .afternoon: return "점심"
        case .evening: return "저녁"
        case .snack: return "간식"
            
        }
    }
}
