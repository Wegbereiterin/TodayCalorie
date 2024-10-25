//
//  Food.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/24/24.
//

import Foundation

struct Food: Codable {
    var uid: String
    var foodName: String // 음식이름
    var calories: Double // 칼로리
    var detail: String // 설명
    var image: String // 이미지
    var date: Date // 날짜
    var timetoEat: String // 시간대
    var like: Bool // 좋아요
    var NumberOfLike: Int // 총 좋아요 수
    var userName: String // 작성자
    var share: Bool
}
