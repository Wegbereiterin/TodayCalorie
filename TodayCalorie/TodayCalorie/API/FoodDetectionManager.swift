//
//  FoodDetectionManager.swift
//  TodayCalorie
//
//  Created by 박선구 on 11/6/24.
//

import UIKit
import Vision
import CoreML

// 음식 감지 결과를 담는 구조체
struct FoodDetection {
    let label: String
    let confidence: Float
    let boundingBox: CGRect
    let modelType: FoodModelType
}

// 모델 타입을 구분하는 열거형
enum FoodModelType: String, CaseIterable {
    case general = "best_2"
    case rice = "rice_detector"
    case kimchiStew = "kimchi_stew_detector"
    case kimchi = "kimchi_detector"
    
    var modelName: String { return rawValue }
}

class FoodDetectionManager {
    static let shared = FoodDetectionManager()
    private var models: [FoodModelType: VNCoreMLModel] = [:]
    
    private init() {
        setupModels()
    }
    
    private func setupModels() {
        // 각 모델 초기화
        FoodModelType.allCases.forEach { modelType in
            do {
                let config = MLModelConfiguration()
                switch modelType {
                case .general:
                    let model = try best_2(configuration: config).model
                    models[modelType] = try VNCoreMLModel(for: model)
                case .rice:
                    let model = try rice_detector(configuration: config).model
                    models[modelType] = try VNCoreMLModel(for: model)
                case .kimchiStew:
                    let model = try kimchi_stew_detector(configuration: config).model
                    models[modelType] = try VNCoreMLModel(for: model)
                case .kimchi:
                    let model = try kimchi_detector(configuration: config).model
                    models[modelType] = try VNCoreMLModel(for: model)
                }
            } catch {
                print("Failed to load \(modelType.modelName) model:", error)
            }
        }
    }
    
    func detectFood(in image: UIImage, completion: @escaping ([FoodDetection]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }
        
        var allDetections: [FoodDetection] = []
        let group = DispatchGroup()
        
        // 각 모델에 대해 병렬로 감지 수행
        for (modelType, model) in models {
            group.enter()
            
            let request = VNCoreMLRequest(model: model) { request, error in
                defer { group.leave() }
                
                if let error = error {
                    print("Detection error for \(modelType.modelName):", error)
                    return
                }
                
                guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
                
                let detections = results
                    .filter { $0.confidence >= 0.5 }
                    .map { observation -> FoodDetection in
                        let label = observation.labels.first?.identifier ?? "unknown"
                        return FoodDetection(
                            label: label,
                            confidence: observation.confidence,
                            boundingBox: observation.boundingBox,
                            modelType: modelType
                        )
                    }
                
                allDetections.append(contentsOf: detections)
            }
            
            request.imageCropAndScaleOption = .scaleFit
            
            do {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                try handler.perform([request])
            } catch {
                print("Request failed for \(modelType.modelName):", error)
                group.leave()
            }
        }
        
        // 모든 감지가 완료되면 결과 반환
        group.notify(queue: .main) {
            // 중복 제거 및 신뢰도 기반 필터링
            let uniqueDetections = self.removeDuplicateDetections(allDetections)
            completion(uniqueDetections)
        }
    }
    
    private func removeDuplicateDetections(_ detections: [FoodDetection]) -> [FoodDetection] {
        // 라벨별로 가장 높은 신뢰도를 가진 감지 결과만 유지
        var uniqueDetections: [String: FoodDetection] = [:]
        
        for detection in detections {
            if let existing = uniqueDetections[detection.label] {
                if detection.confidence > existing.confidence {
                    uniqueDetections[detection.label] = detection
                }
            } else {
                uniqueDetections[detection.label] = detection
            }
        }
        
        return Array(uniqueDetections.values)
    }
}

struct FoodNameMapper {
    static let nameMap: [String: String] = [
        "apple": "사과",
        "banana": "바나나",
        "watermelon": "수박",
        "pineapple": "파인애플",
        "orange": "오렌지",
        "grape": "포도",
        "kimchi": "김치",
        "kimchijjigae": "김치찌개",
        "rice": "쌀밥"
    ]
    
    static func toKorean(_ englishName: String) -> String {
        return nameMap[englishName.lowercased()] ?? englishName
    }
}
