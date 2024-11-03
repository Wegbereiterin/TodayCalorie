//
//  FoodModel.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

// 음식 타입 열거형
enum FoodType {
    case rice
    case soup
    case sideDish
    case pasta
    case kimchi
    case potato
    case rice_cake
    case custom
    
    var portionOptions: [(amount: String, gram: String, calorie: String)] {
        switch self {
        case .rice:
            return [
                ("1 공기", "200g", "300 Kcal"),
                ("2 공기", "400g", "600 Kcal"),
                ("1/2 공기", "100g", "150 Kcal"),
                ("1/4 공기", "50g", "75 Kcal")
            ]
        case .soup:
            return [
                ("1 그릇", "300g", "150 Kcal"),
                ("2 그릇", "600g", "300 Kcal"),
                ("1/2 그릇", "150g", "75 Kcal")
            ]
        case .pasta:
            return [
                ("1 인분", "250g", "400 Kcal"),
                ("1.5 인분", "375g", "600 Kcal"),
                ("0.5 인분", "125g", "200 Kcal")
            ]
        case .custom:
            return [
                ("1 인분", "250g", "400 Kcal"),
                ("1.5 인분", "375g", "600 Kcal"),
                ("0.5 인분", "125g", "200 Kcal")
            ]
            // 다른 음식 타입들에 대한 옵션도 추가...
        default:
            return [
                ("1 인분", "100g", "100 Kcal"),
                ("2 인분", "200g", "200 Kcal"),
                ("1/2 인분", "50g", "50 Kcal")
            ]
        }
    }
}

// 음식 데이터 구조체
struct Food {
    let image: UIImage
    let name: String
    let type: FoodType
    let baseCalorie: Int?
    var selectedAmount: String  // 변경 가능하도록 var로 선언
    var selectedCalorie: Int    // 변경 가능하도록 var로 선언
}

struct FoodCalorie: Codable {
    let name: String
    let gram: Int
    let calorie: Int
}


