//
//  FoodPost.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/3/24.
//

import UIKit
import Firebase
import FirebaseFirestore

struct FoodItem: Codable {
    let name: String
    let calories: Int      // 선택된 양에 따른 실제 칼로리
    let baseCalorie: Int   // 기본 1인분 칼로리
    let amount: String     // 선택된 양 (예: "1/2인분", "1인분" 등)
    let type: String
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "calories": calories,
            "baseCalorie": baseCalorie,
            "amount": amount,
            "type": type
        ]
    }
}

struct FoodPost: Codable {
   let id: String
   let userUID: String
   let title: String
   let foodImages: [String]
   let description: String
   let foodItems: [FoodItem]
   let totalCalories: Int
   let createdAt: Timestamp
   let mealTime: String
   let isShared: Bool
   let likeCount: Int
   
   func toDictionary() -> [String: Any] {
       return [
           "id": id,
           "userUID": userUID,
           "title": title,
           "foodImages": foodImages,
           "description": description,
           "foodItems": foodItems.map { $0.toDictionary() },
           "totalCalories": totalCalories,
           "createdAt": createdAt,
           "mealTime": mealTime,
           "isShared": isShared,
           "likeCount": likeCount
       ]
   }
}
