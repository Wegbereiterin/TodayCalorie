//
//  ImageSectionView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit
import Vision

class ImageSectionView: UIView {
    
    private var detectionLabels: [String: UILabel] = [:]  // 음식 라벨용
    private var warningLabels: [UILabel] = []
    private var boundingBoxViews: [UIView] = []
    
    private let imageContainer: UIView = {
            let view = UIView()
        view.backgroundColor = .white
            view.layer.cornerRadius = 15
            view.clipsToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.backgroundColor = .clear // 배경색 추가해서 실제 영역 확인
            iv.layer.cornerRadius = 15
            iv.clipsToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
    
    private let calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "총 섭취 칼로리: 0 Kcal"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        addSubview(calorieLabel)
        
        NSLayoutConstraint.activate([
                    imageContainer.topAnchor.constraint(equalTo: topAnchor),
                    imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                    imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                    imageContainer.heightAnchor.constraint(equalToConstant: 300), // 고정 크기로 변경
                    
                    // 이미지뷰도 고정된 크기로 설정하고 중앙 정렬
                    imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: 300),  // 고정 너비
                    imageView.heightAnchor.constraint(equalToConstant: 300), // 고정 높이
                    
                    calorieLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 16),
                    calorieLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                    calorieLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                    calorieLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
    }
    
    func configure(with image: UIImage?, calories: Int) {
        imageView.image = image
        calorieLabel.text = "총 섭취 칼로리: \(calories) Kcal"
    }
    
    private func calculateImageRect() -> CGRect {
        guard let image = imageView.image else { return .zero }
        
        let viewSize = imageView.bounds.size
        let imageSize = image.size
        
        // AspectFit 계산
        let scaleWidth = viewSize.width / imageSize.width
        let scaleHeight = viewSize.height / imageSize.height
        let scale = min(scaleWidth, scaleHeight)
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        
        let offsetX = (viewSize.width - scaledWidth) / 2
        let offsetY = (viewSize.height - scaledHeight) / 2
        
        return CGRect(x: offsetX, y: offsetY, width: scaledWidth, height: scaledHeight)
    }
    
    func getImageFrame() -> CGRect {
            guard let image = imageView.image else { return .zero }
            
            let imageViewSize = imageView.frame.size
            let imageSize = image.size
            
            // 이미지와 이미지뷰의 비율 계산
            let imageAspect = imageSize.width / imageSize.height
            let imageViewAspect = imageViewSize.width / imageViewSize.height
            
            var drawingRect: CGRect = .zero
            
            if imageAspect > imageViewAspect {
                // 이미지가 더 넓은 경우
                let scaledHeight = imageViewSize.width / imageAspect
                let y = (imageViewSize.height - scaledHeight) / 2
                drawingRect = CGRect(x: 0, y: y, width: imageViewSize.width, height: scaledHeight)
            } else {
                // 이미지가 더 높은 경우
                let scaledWidth = imageViewSize.height * imageAspect
                let x = (imageViewSize.width - scaledWidth) / 2
                drawingRect = CGRect(x: x, y: 0, width: scaledWidth, height: imageViewSize.height)
            }
            
            return drawingRect
        }
    
    func addDetectionLabel(for observation: VNRecognizedObjectObservation, foodName: String) {
        let labelView = UILabel()
        labelView.backgroundColor = .main.withAlphaComponent(0.7)
        labelView.textColor = .white
        labelView.font = .systemFont(ofSize: 18, weight: .bold)
        labelView.text = " \(foodName) \(Int(observation.confidence * 100))% "
        labelView.textAlignment = .center
        labelView.layer.cornerRadius = 8
        labelView.clipsToBounds = true
        
        imageView.addSubview(labelView)
        labelView.sizeToFit()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("\nDEBUG: ===== 라벨 위치 계산 =====")
            print("DEBUG: Vision boundingBox: \(observation.boundingBox)")
            
            // 바운딩 박스와 동일한 방식으로 중심점 계산
            let centerX = observation.boundingBox.midX * 300
            let centerY = (1 - observation.boundingBox.midY) * 300
            
            print("DEBUG: 계산된 중심점: (\(centerX), \(centerY))")
            
            labelView.center = CGPoint(x: centerX, y: centerY)
        }
        
        detectionLabels[foodName] = labelView
    }
    
    func updateDetections(_ observations: [VNRecognizedObjectObservation]) {
            // 기존 라벨과 바운딩 박스 제거
            clearDetectionLabels()
            
            // confidence가 가장 높은 것만 저장
            var uniqueDetections: [String: VNRecognizedObjectObservation] = [:]
            
            for observation in observations {
                guard let label = observation.labels.first else { continue }
                let foodName = label.identifier
                
                if let existingObs = uniqueDetections[foodName] {
                    if observation.confidence > existingObs.confidence {
                        uniqueDetections[foodName] = observation
                    }
                } else {
                    uniqueDetections[foodName] = observation
                }
            }
            
            // 바운딩 박스를 먼저 추가하고, 그 다음 라벨 추가
            for (foodName, observation) in uniqueDetections {
                addDetectionLabel(for: observation, foodName: foodName)
            }
            
            // 레이아웃 업데이트 강제
            layoutIfNeeded()
        }
    
    func clearDetectionLabels() {
        detectionLabels.values.forEach { $0.removeFromSuperview() }
        detectionLabels.removeAll()
    }
    
    func removeDetectionLabel(for foodName: String) {
        detectionLabels[foodName]?.removeFromSuperview()
        detectionLabels.removeValue(forKey: foodName)
    }
    
    func addWarningLabel(for observation: VNRecognizedObjectObservation) {
            let label = UILabel()
            label.text = "⚠️"
            label.font = .systemFont(ofSize: 24)
            label.textAlignment = .center
            
            imageView.addSubview(label)
            label.sizeToFit()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let imageRect = self.calculateImageRect()
                
                // Vision 좌표를 UIKit 좌표로 변환
                let centerX = observation.boundingBox.midX * imageRect.width + imageRect.minX
                let centerY = (1 - observation.boundingBox.midY) * imageRect.height + imageRect.minY
                
                label.center = CGPoint(x: centerX, y: centerY)
            }
            
            warningLabels.append(label)
        }

    func updateWarningLabels(_ observations: [VNRecognizedObjectObservation]) {
        clearWarningLabels()
        observations.forEach { addWarningLabel(for: $0) }
    }

    func clearWarningLabels() {
        warningLabels.forEach { $0.removeFromSuperview() }
        warningLabels.removeAll()
    }
}
