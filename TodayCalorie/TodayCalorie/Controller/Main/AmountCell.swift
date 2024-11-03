//
//  AmountCell.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

class AmountCell: UITableViewCell {
    
    private var isCustomSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gramLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calorieLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(amountLabel)
        containerView.addSubview(gramLabel)
        containerView.addSubview(calorieLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            amountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            amountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            gramLabel.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 8),
            gramLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            calorieLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            calorieLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(amount: String, gram: String, calorie: String) {
        amountLabel.text = amount
        gramLabel.text = gram
        calorieLabel.text = calorie
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.backgroundColor = self.isCustomSelected ? .main : .white
            self.amountLabel.textColor = self.isCustomSelected ? .black : .black
            self.gramLabel.textColor = self.isCustomSelected ? .gray : .darkGray
            self.calorieLabel.textColor = self.isCustomSelected ? .black : .black
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isCustomSelected = selected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCustomSelected = false
        updateAppearance()
    }
}
