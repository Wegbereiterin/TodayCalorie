//
//  FoodOptionView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

protocol FoodOptionViewDelegate: AnyObject {
    func foodOptionView(_ view: FoodOptionView, didSelectAmount amount: Int, calories: Int)
}

class FoodOptionView: UIView {
    // MARK: - Properties
    
    private var customCalorie: Int = 0
    
    private let amountTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGray6
        table.separatorStyle = .none
        table.isScrollEnabled = true
        table.layer.cornerRadius = 10
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var selectedIndexPath: IndexPath?
    private var currentFoodName: String?
    private var foodSelections: [String: IndexPath] = [:]
    
    private var currentOptions: [FoodPortionOption] = []
    private var selectedOption: FoodPortionOption?
    weak var delegate: FoodOptionViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.text = "섭취 량"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6  // 뷰 자체의 배경색도 회색으로
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        
        // 테이블뷰 설정
        amountTableView.delegate = self
        amountTableView.dataSource = self
        amountTableView.register(AmountCell.self, forCellReuseIdentifier: "AmountCell")
        
        addSubview(amountTableView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            amountTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            amountTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(for foodName: String, customCalorie: Int? = nil) {
        currentFoodName = foodName
        
        if let fruitType = FruitType(rawValue: foodName) {
            if fruitType == .custom && customCalorie != nil {
                currentOptions = FruitType.createCustomPortionOptions(baseCalorie: customCalorie!)
            } else {
                currentOptions = fruitType.portionOptions
            }
        } else if let customCalorie = customCalorie {
            currentOptions = FruitType.createCustomPortionOptions(baseCalorie: customCalorie)
        }
        
        amountTableView.reloadData()
        
        // 현재 음식에 대한 이전 선택 상태 복원
        if let savedIndexPath = foodSelections[foodName] {
            selectedIndexPath = savedIndexPath
            amountTableView.selectRow(at: savedIndexPath, animated: false, scrollPosition: .none)
            if let cell = amountTableView.cellForRow(at: savedIndexPath) as? AmountCell {
                cell.setSelected(true, animated: false)
            }
        } else {
            // 이전 선택이 없으면 모든 선택 해제
            selectedIndexPath = nil
            if let selected = amountTableView.indexPathForSelectedRow {
                amountTableView.deselectRow(at: selected, animated: false)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FoodOptionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath) as! AmountCell
        let option = currentOptions[indexPath.row]
        cell.configure(amount: option.amount, gram: "\(option.gram)g", calorie: "\(option.calorie) Kcal")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentFoodName = currentFoodName else { return }
        
        // 이전 선택 해제
        if let previousIndexPath = selectedIndexPath,
           let previousCell = tableView.cellForRow(at: previousIndexPath) as? AmountCell {
            previousCell.setSelected(false, animated: true)
        }
        
        // 새로운 선택
        selectedIndexPath = indexPath
        foodSelections[currentFoodName] = indexPath
        selectedOption = currentOptions[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) as? AmountCell {
            cell.setSelected(true, animated: true)
        }
        
        if let option = selectedOption {
            delegate?.foodOptionView(self, didSelectAmount: option.gram, calories: option.calorie)
        }
    }
    
    func clearSelection(for foodName: String) {
        foodSelections.removeValue(forKey: foodName)
        if currentFoodName == foodName {
            selectedIndexPath = nil
            amountTableView.reloadData()
        }
    }
}
