//
//  MealTimeSelectionView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

enum MealTime: String {
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

protocol MealTimeSelectionViewDelegate: AnyObject {
    func mealTimeSelectionView(_ view: MealTimeSelectionView, didSelect mealTime: MealTime)
}

class MealTimeSelectionView: UIView {
    // MARK: - Properties
    weak var delegate: MealTimeSelectionViewDelegate?
    private var selectedTime: MealTime?
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var morningButton = createTimeButton(for: .morning)
    private lazy var afternoonButton = createTimeButton(for: .afternoon)
    private lazy var eveningButton = createTimeButton(for: .evening)
    private lazy var snackButton = createTimeButton(for: .snack)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(buttonStack)
        
        buttonStack.addArrangedSubview(morningButton)
        buttonStack.addArrangedSubview(afternoonButton)
        buttonStack.addArrangedSubview(eveningButton)
        buttonStack.addArrangedSubview(snackButton)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func createTimeButton(for time: MealTime) -> EatTimeButton {
        let button = EatTimeButton()
        button.configure(type: time)
        button.addTarget(self, action: #selector(timeButtonTapped(_:)), for: .touchUpInside)
        button.tag = [MealTime.morning, .afternoon, .evening, .snack].firstIndex(of: time) ?? 0
        return button
    }
    
    // MARK: - Actions
    @objc private func timeButtonTapped(_ sender: EatTimeButton) {
        let times: [MealTime] = [.morning, .afternoon, .evening, .snack]
        let selectedTime = times[sender.tag]
        
        // 이전 선택 해제
        [morningButton, afternoonButton, eveningButton, snackButton].forEach { button in
            button.isOn = false
        }
        
        // 새로운 선택
        sender.isOn = true
        self.selectedTime = selectedTime
        delegate?.mealTimeSelectionView(self, didSelect: selectedTime)
    }
    
    // MARK: - Public Methods
    func getSelectedTime() -> MealTime? {
        return selectedTime
    }
    
    func clearSelection() {
        selectedTime = nil
        [morningButton, afternoonButton, eveningButton, snackButton].forEach { button in
            button.isOn = false
        }
    }
}

