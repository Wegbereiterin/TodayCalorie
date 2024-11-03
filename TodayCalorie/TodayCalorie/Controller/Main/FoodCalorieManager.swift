//
//  FoodCalorieManager.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

class FoodCalorieManager {
    static let shared = FoodCalorieManager()
    private var foodCalories: [String: FoodCalorie] = [:]
    
    private init() {
        print("FoodCalorieManager 초기화 시작")
        loadCalorieData()
    }
    
    private func loadCalorieData() {
        if let path = Bundle.main.path(forResource: "FoodCalories", ofType: "json") {
            print("JSON 파일 경로 찾음: \(path)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let calories = try decoder.decode([FoodCalorie].self, from: data)
                foodCalories = Dictionary(uniqueKeysWithValues: calories.map { ($0.name, $0) })
                print("로드된 음식 칼로리 데이터:", foodCalories)
            } catch {
                print("칼로리 데이터 로드 실패:", error)
            }
        } else {
            print("JSON 파일을 찾을 수 없음")
        }
    }
    
    func getCalorie(for foodName: String) -> Int {
        return foodCalories[foodName]?.calorie ?? 0
    }
}
