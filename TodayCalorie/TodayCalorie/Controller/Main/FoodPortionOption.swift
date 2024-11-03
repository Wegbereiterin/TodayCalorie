//
//  FoodPortionOption.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

struct FoodPortionOption {
    let amount: String
    let gram: Int
    let calorie: Int
}

enum FruitType: String {
    case apple = "Apple"
    case banana = "Banana"
    case grape = "Grape"
    case orange = "Orange"
    case pineapple = "Pineapple"
    case watermelon = "Watermelon"
    case custom = "Custom"
    
    var baseInfo: (gramPerUnit: Int, caloriePerUnit: Int) {
        switch self {
        case .apple:
            return (182, 95)   // 1개 기준
        case .banana:
            return (118, 105)  // 1개 기준
        case .grape:
            return (2, 2)      // 1알 기준
        case .orange:
            return (131, 62)   // 1개 기준
        case .pineapple:
            return (165, 83)   // 1조각 기준
        case .watermelon:
            return (286, 86)   // 1조각 기준
        case .custom:
            return (0, 0)      // custom은 별도 처리
        }
    }
    
    var portionOptions: [FoodPortionOption] {
        let (gramPerUnit, caloriePerUnit) = baseInfo
        
        switch self {
        case .apple:
            return [
                FoodPortionOption(amount: "1/4개", gram: gramPerUnit/4, calorie: caloriePerUnit/4),
                FoodPortionOption(amount: "1/2개", gram: gramPerUnit/2, calorie: caloriePerUnit/2),
                FoodPortionOption(amount: "1개", gram: gramPerUnit, calorie: caloriePerUnit),
                FoodPortionOption(amount: "2개", gram: gramPerUnit*2, calorie: caloriePerUnit*2),
                FoodPortionOption(amount: "3개", gram: gramPerUnit*3, calorie: caloriePerUnit*3)
            ]
            
        case .banana:
            return [
                FoodPortionOption(amount: "1/2개", gram: gramPerUnit/2, calorie: caloriePerUnit/2),
                FoodPortionOption(amount: "1개", gram: gramPerUnit, calorie: caloriePerUnit),
                FoodPortionOption(amount: "1.5개", gram: Int(Double(gramPerUnit)*1.5), calorie: Int(Double(caloriePerUnit)*1.5)),
                FoodPortionOption(amount: "2개", gram: gramPerUnit*2, calorie: caloriePerUnit*2)
            ]
            
        case .grape:
            return [
                FoodPortionOption(amount: "5알", gram: gramPerUnit*5, calorie: caloriePerUnit*5),
                FoodPortionOption(amount: "10알", gram: gramPerUnit*10, calorie: caloriePerUnit*10),
                FoodPortionOption(amount: "15알", gram: gramPerUnit*15, calorie: caloriePerUnit*15),
                FoodPortionOption(amount: "20알", gram: gramPerUnit*20, calorie: caloriePerUnit*20)
            ]
            
        case .orange:
            return [
                FoodPortionOption(amount: "1/2개", gram: gramPerUnit/2, calorie: caloriePerUnit/2),
                FoodPortionOption(amount: "1개", gram: gramPerUnit, calorie: caloriePerUnit),
                FoodPortionOption(amount: "1.5개", gram: Int(Double(gramPerUnit)*1.5), calorie: Int(Double(caloriePerUnit)*1.5)),
                FoodPortionOption(amount: "2개", gram: gramPerUnit*2, calorie: caloriePerUnit*2)
            ]
            
        case .pineapple:
            return [
                FoodPortionOption(amount: "1조각", gram: gramPerUnit, calorie: caloriePerUnit),
                FoodPortionOption(amount: "2조각", gram: gramPerUnit*2, calorie: caloriePerUnit*2),
                FoodPortionOption(amount: "3조각", gram: gramPerUnit*3, calorie: caloriePerUnit*3),
                FoodPortionOption(amount: "4조각", gram: gramPerUnit*4, calorie: caloriePerUnit*4)
            ]
            
        case .watermelon:
            return [
                FoodPortionOption(amount: "1조각", gram: gramPerUnit, calorie: caloriePerUnit),
                FoodPortionOption(amount: "2조각", gram: gramPerUnit*2, calorie: caloriePerUnit*2),
                FoodPortionOption(amount: "3조각", gram: gramPerUnit*3, calorie: caloriePerUnit*3),
                FoodPortionOption(amount: "4조각", gram: gramPerUnit*4, calorie: caloriePerUnit*4)
            ]
            
        case .custom:
            return []  // custom은 별도 처리
        }
    }
    
    static func createCustomPortionOptions(baseCalorie: Int) -> [FoodPortionOption] {
        return [
            FoodPortionOption(amount: "1/4인분", gram: 0, calorie: baseCalorie/4),
            FoodPortionOption(amount: "1/2인분", gram: 0, calorie: baseCalorie/2),
            FoodPortionOption(amount: "1인분", gram: 0, calorie: baseCalorie),
            FoodPortionOption(amount: "1.5인분", gram: 0, calorie: Int(Double(baseCalorie) * 1.5)),
            FoodPortionOption(amount: "2인분", gram: 0, calorie: baseCalorie * 2)
        ]
    }
}
