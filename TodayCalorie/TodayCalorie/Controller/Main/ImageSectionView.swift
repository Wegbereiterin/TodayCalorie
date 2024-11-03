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
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
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
    
    func getImageFrame() -> CGRect {
        guard let image = imageView.image else { return .zero }
        
        // 이미지뷰의 bounds가 0이면 layoutIfNeeded() 호출
        if imageView.bounds.width == 0 || imageView.bounds.height == 0 {
            self.layoutIfNeeded()
        }
        
        // 실제 이미지뷰의 프레임
        let viewBounds = imageView.bounds
        print("ImageView bounds: \(viewBounds)") // 디버깅용
        
        // 이미지와 이미지뷰의 비율 계산
        let imageRatio = image.size.width / image.size.height
        let viewRatio = viewBounds.width / viewBounds.height
        
        var drawingRect = CGRect.zero
        
        if imageRatio > viewRatio {
            // 이미지가 더 넓은 경우
            let width = viewBounds.width
            let height = width / imageRatio
            let y = (viewBounds.height - height) / 2
            drawingRect = CGRect(x: 0, y: y, width: width, height: height)
        } else {
            // 이미지가 더 높은 경우
            let height = viewBounds.height
            let width = height * imageRatio
            let x = (viewBounds.width - width) / 2
            drawingRect = CGRect(x: x, y: 0, width: width, height: height)
        }
        
        return drawingRect
    }
    
    func addDetectionLabel(for observation: VNRecognizedObjectObservation, foodName: String) {
        print("Adding label for food: \(foodName)")
        
        self.layoutIfNeeded()
        
        let labelView = UILabel()
        labelView.backgroundColor = .main.withAlphaComponent(0.7)
        labelView.textColor = .white
        labelView.font = .systemFont(ofSize: 18, weight: .bold)
        labelView.text = " \(foodName) \(Int(observation.confidence * 100))% "
        labelView.layer.cornerRadius = 8
        labelView.clipsToBounds = true
        
        imageView.addSubview(labelView)
        labelView.sizeToFit()
        
        let imageFrame = getImageFrame()
        print("Image frame: \(imageFrame)")
        
        guard imageFrame.width > 0, imageFrame.height > 0 else {
            print("Invalid image frame")
            return
        }
        
        // 객체의 중심점 계산
        let centerX = imageFrame.origin.x + (observation.boundingBox.midX * imageFrame.width)
        let centerY = imageFrame.origin.y + ((1 - observation.boundingBox.midY) * imageFrame.height)
        
        // 레이블을 객체의 중심에 배치 (레이블의 크기를 고려하여 조정)
        let x = centerX - (labelView.bounds.width / 2)
        let y = centerY - (labelView.bounds.height / 2)
        
        print("Label position: x: \(x), y: \(y)")
        
        labelView.frame.origin = CGPoint(x: x, y: y)
        
        detectionLabels[foodName] = labelView
    }
    
    func updateDetections(_ observations: [VNRecognizedObjectObservation]) {
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
        
        // 각 고유한 음식에 대해 라벨 추가
        for (foodName, observation) in uniqueDetections {
            addDetectionLabel(for: observation, foodName: foodName)
        }
    }
    
    func clearDetectionLabels() {
        detectionLabels.values.forEach { $0.removeFromSuperview() }
        detectionLabels.removeAll()
    }
    
    func removeDetectionLabel(for foodName: String) {
        detectionLabels[foodName]?.removeFromSuperview()
        detectionLabels.removeValue(forKey: foodName)
    }
    
    private func createWarningLabel() -> UILabel {
        let label = UILabel()
        label.text = "⚠️"
        label.font = .systemFont(ofSize: 24)  // 경고 이모지 크기 조정
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func addWarningLabel(for observation: VNRecognizedObjectObservation) {
        let label = UILabel()
        //            label.backgroundColor = .main.withAlphaComponent(0.7)
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = " ⚠️ "
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        
        imageView.addSubview(label)
        label.sizeToFit()
        
        let centerX = observation.boundingBox.midX * imageView.bounds.width
        let centerY = (1 - observation.boundingBox.midY) * imageView.bounds.height
        
        let x = centerX - (label.bounds.width / 2)
        let y = centerY - (label.bounds.height / 2)
        
        label.frame.origin = CGPoint(x: x, y: y)
        
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
