//
//  Comment.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/4/24.
//

import UIKit
import FirebaseFirestore

struct Comment: Codable {
    let id: String
    let userUID: String
    let content: String
    let createdAt: Timestamp
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userUID": userUID,
            "content": content,
            "createdAt": createdAt
        ]
    }
}
