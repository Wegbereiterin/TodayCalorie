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
    
    private init() {}
    
    private func uploadImage(_ image: UIImage) async throws -> String {
        print("DEBUG: 이미지 업로드 시작")
        
        return try await withCheckedThrowingContinuation { continuation in
            // 1. 이미지 데이터 변환
            guard let imageData = image.jpegData(compressionQuality: 0.6) else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"]))
                return
            }
            
            // 2. Storage 참조 생성
            let storage = Storage.storage()
            print("DEBUG: Storage 버킷: \(storage.reference().bucket)")
            
            // 3. 경로 및 파일명 설정
            let filename = "test.jpg"  // 테스트용 고정 파일명
            let imageRef = storage.reference().child(filename)
            
            print("DEBUG: Storage 경로: \(imageRef.fullPath)")
            
            // 4. 메타데이터 설정
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // 5. 업로드 시작
            print("DEBUG: 업로드 시작...")
            let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("DEBUG: 업로드 실패 상세: \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                
                print("DEBUG: 메타데이터: \(String(describing: metadata))")
                continuation.resume(returning: filename)
            }
            
            uploadTask.observe(.progress) { snapshot in
                let progress = snapshot.progress?.fractionCompleted ?? 0
                print("DEBUG: 업로드 진행률: \(progress)")
            }
        }
    }
    
    func testImageUpload(_ image: UIImage) async throws -> String {
        return try await uploadImage(image)
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
