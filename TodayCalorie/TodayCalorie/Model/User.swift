//
//  User.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/29/24.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    let uid: String
    let name: String
    let email: String
}
