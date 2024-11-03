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
   let calories: Int
   let type: String
   
   func toDictionary() -> [String: Any] {
       return [
           "name": name,
           "calories": calories,
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
