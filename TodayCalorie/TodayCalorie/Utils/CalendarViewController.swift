//
//  CalendarViewController.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/4/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol DateSelectionDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

class CalendarViewController: UIViewController {
    private let db = Firestore.firestore()
    private var dailyCalories: [String: Int] = [:]
    
    weak var delegate: DateSelectionDelegate?
    private var selectedDate: DateComponents?
    
    private lazy var dateView: UICalendarView = {
        let view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.calendar = .current
        view.locale = .current
        view.fontDesign = .rounded
        view.delegate = self
        view.wantsDateDecorations = true
        
        // 현재 달 표시 설정
//        let currentDateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
//        view.visibleDateComponents = currentDateComponents
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        view.selectionBehavior = selection
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
        // viewDidLoad에서 데이터를 미리 로드
        Task {
            await loadCalorieData()
        }
    }
    
    private func configureUI() {
        view.addSubview(dateView)
        
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            // 높이 제약 추가
            dateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)  // 화면 높이의 60%
        ])
    }
    
    private func loadCalorieData() async {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("food_posts")
                .whereField("userUID", isEqualTo: userUID)
                .getDocuments()
            
            var newDailyCalories: [String: Int] = [:]
            
            for document in snapshot.documents {
                let data = document.data()
                guard let createdAt = data["createdAt"] as? Timestamp,
                      let totalCalories = data["totalCalories"] as? Int else { continue }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: createdAt.dateValue())
                
                newDailyCalories[dateString, default: 0] += totalCalories
            }
            
            await MainActor.run {
                self.dailyCalories = newDailyCalories
                
                // 현재 달의 모든 날짜에 대한 DateComponents 생성
                let calendar = Calendar.current
                let now = Date()
                let components = calendar.dateComponents([.year, .month], from: now)
                guard let firstDay = calendar.date(from: components),
                      let range = calendar.range(of: .day, in: .month, for: firstDay) else { return }
                
                let dateComponents = range.compactMap { day -> DateComponents in
                    var comp = components
                    comp.day = day
                    return comp
                }
                
                self.dateView.reloadDecorations(forDateComponents: dateComponents, animated: true)
                self.dateView.setNeedsDisplay()
            }
            
        } catch {
            print("DEBUG: 데이터 로드 실패: \(error.localizedDescription)")
        }
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = Calendar.current.date(from: dateComponents),
              let dateString = dateFormatter.string(from: date).removingPercentEncoding,
              let calories = dailyCalories[dateString] else {
            return nil
        }
        
        let textColor: UIColor = calories >= 2000 ? .red : .black
        
        // 선택된 날짜인 경우 배경색 추가
        let isSelected = dateComponents == selectedDate
        
        return .customView {
            let container = UIView()
            container.backgroundColor = isSelected ? .systemBlue.withAlphaComponent(0.2) : .clear
            
            let label = UILabel()
            label.text = "\(calories)"
            label.font = .systemFont(ofSize: 10)
            label.textColor = textColor
            label.textAlignment = .center
            
            container.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            
            return container
        }
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }
        
        selectedDate = dateComponents
        delegate?.didSelectDate(date)
        dismiss(animated: true)
    }
}
