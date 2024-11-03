//
//  FoodPostManager.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/3/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class FoodPostManager {
    static let shared = FoodPostManager()
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    private func uploadImage(_ image: UIImage) async throws -> String {
        print("DEBUG: 이미지 업로드 시작")
        
        return try await withCheckedThrowingContinuation { continuation in
            // 1. 이미지 데이터 변환
            guard let imageData = image.jpegData(compressionQuality: 0.6) else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"]))
                return
            }
            
            // 2. 파일명 생성 (UUID + 타임스탬프)
            let filename = "\(UUID().uuidString)_\(Int(Date().timeIntervalSince1970)).jpg"
            let imageRef = storage.child("food_images").child(filename)
            
            print("DEBUG: 업로드 시도 - 경로: \(imageRef.fullPath)")
            
            // 3. 메타데이터 설정
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // 4. 업로드
            let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    print("DEBUG: 업로드 실패: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                
                // 5. 업로드 성공 후 다운로드 URL 가져오기
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("DEBUG: URL 가져오기 실패: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let downloadURL = url else {
                        continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "다운로드 URL 없음"]))
                        return
                    }
                    
                    print("DEBUG: 업로드 성공! URL: \(downloadURL.absoluteString)")
                    continuation.resume(returning: downloadURL.absoluteString)
                }
            }
            
            // 업로드 진행상황 모니터링
            uploadTask.observe(.progress) { snapshot in
                print("DEBUG: 업로드 진행률: \(snapshot.progress?.fractionCompleted ?? 0)")
            }
        }
    }
    
    // 게시글 업로드
    func uploadFoodPost(
        title: String,
        image: UIImage,
        description: String,
        foods: [Food],
        totalCalories: Int,
        mealTime: MealTime,
        isShared: Bool
    ) async throws {
        // 1. 사용자 확인
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인이 필요합니다"])
        }
        
        do {
            // 2. 이미지 업로드
            let imageURL = try await uploadImage(image)
            print("DEBUG: 이미지 업로드 완료")
            
            // 3. Food 아이템 변환
            let foodItems = foods.map { food in
                FoodItem(
                    name: food.name,
                    calories: food.selectedCalorie,  // 선택된 양에 따른 실제 칼로리 사용
                    baseCalorie: food.baseCalorie ?? 0,
                    amount: food.selectedAmount,     // 선택된 양 사용
                    type: String(describing: food.type)
                )
            }
            
            // 4. 게시글 데이터 생성
            let postID = UUID().uuidString
            let post = FoodPost(
                id: postID,
                userUID: userUID,
                title: title,
                foodImages: [imageURL],
                description: description,
                foodItems: foodItems,
                totalCalories: totalCalories,
                createdAt: Timestamp(),
                mealTime: mealTime.rawValue,
                isShared: isShared,
                likeCount: 0
            )
            
            // 5. Firestore에 저장
            try await db.collection("food_posts").document(postID).setData(post.toDictionary())
            
            if isShared {
                try await db.collection("posts").document(postID).setData(post.toDictionary())
            }
            
            print("DEBUG: 게시글 업로드 완료")
            
        } catch {
            print("DEBUG: 업로드 실패: \(error)")
            throw error
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let height = width / size.width * size.height
        let newSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
