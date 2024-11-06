//
//  AddFoodController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/25/24.
//

import UIKit
import Vision
import CoreML

class AddFoodController: UIViewController {
    // MARK: - Properties
    
    private var hasInappropriateContent: Bool = false
    
    private var detectionBoxes: [UIView] = []
    
    private var selectedFoodCalories: [String: Int] = [:]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 식사를 하셨나요?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 31
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Custom Components
    private let imageSectionView: ImageSectionView = {
        let view = ImageSectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let foodGalleryView: FoodGalleryView = {
        let view = FoodGalleryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let foodContentView: FoodContentView = {
        let view = FoodContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let foodOptionView: FoodOptionView = {
        let view = FoodOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let mealTimeSelectionView: MealTimeSelectionView = {
        let view = MealTimeSelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shareOptionView: ShareOptionView = {
        let view = ShareOptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addButtonView: AddButtonView = {
        let view = AddButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Data
//    private lazy var selectedFoodCalories: [Int: Int] = [:]
    private lazy var totalCalories: Int = 0 {
        didSet {
            imageSectionView.configure(with: imageSectionView.imageView.image, calories: totalCalories)
        }
    }
    
    
    private var isShowingOptions: Bool = false {
        didSet {
            if isShowingOptions {
                foodContentView.isHidden = true
                foodOptionView.isHidden = false
            } else {
                foodContentView.isHidden = false
                foodOptionView.isHidden = true
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var foods: [Food] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegates()
        setupKeyboardHandling()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setupDelegates() {
        foodGalleryView.delegate = self
        foodOptionView.delegate = self
        mealTimeSelectionView.delegate = self
        shareOptionView.delegate = self
        addButtonView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(scrollView)
        view.addSubview(addButtonView)
        scrollView.addSubview(stackView)
        
        // 컨테이너 뷰 설정
        contentContainer.addSubview(foodContentView)
        contentContainer.addSubview(foodOptionView)
        
        // Add components to stack
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageSectionView)
        stackView.addArrangedSubview(foodGalleryView)
        stackView.addArrangedSubview(contentContainer)  // foodContentView 대신 컨테이너 추가
        stackView.addArrangedSubview(mealTimeSelectionView)
        stackView.addArrangedSubview(shareOptionView)
        
        // ContentView와 OptionView의 제약조건 설정
        NSLayoutConstraint.activate([
            contentContainer.heightAnchor.constraint(equalToConstant: 270),  // 적절한 높이 설정
            
            foodContentView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            foodContentView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            foodContentView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            foodContentView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            
            foodOptionView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            foodOptionView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            foodOptionView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            foodOptionView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addButtonView.topAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            addButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButtonView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }
    
    private func processImage(_ image: UIImage) {
        detectFoods(in: image)
        detectInappropriateContent(in: image)
    }
    
    private func detectInappropriateContent(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        do {
            let config = MLModelConfiguration()
            let model = try Middle_Finger_Detection(configuration: config).model
            let visionModel = try VNCoreMLModel(for: model)
            
            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.processGestureDetections(for: request, error: error)
            }
            request.imageCropAndScaleOption = .scaleFit
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
            
        } catch {
            print("Gesture detection error:", error)
        }
    }
    
    private func processGestureDetections(for request: VNRequest, error: Error?) {
        guard error == nil,
              let observations = request.results as? [VNRecognizedObjectObservation] else { return }
        
        let validDetections = observations.filter { $0.confidence >= 0.7 }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hasInappropriateContent = !validDetections.isEmpty
            
            // ImageSectionView에 경고 라벨 업데이트 요청
            self.imageSectionView.updateWarningLabels(validDetections)
        }
    }
    
    func setupNavigationBar() {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeModal))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func reindexFoodCalories() {
        // 이름을 키로 사용하는 새로운 딕셔너리 생성
        let newSelectedFoodCalories: [String: Int] = Dictionary(uniqueKeysWithValues:
            foods.map { food in
                (food.name, selectedFoodCalories[food.name] ?? food.selectedCalorie)
            }
        )
        selectedFoodCalories = newSelectedFoodCalories
        totalCalories = selectedFoodCalories.values.reduce(0, +)
    }
    
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height,
            right: 0
        )
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeView = UIResponder.currentFirstResponder as? UIView,
           activeView.isDescendant(of: scrollView) {
            let activeFrame = activeView.convert(activeView.bounds, to: scrollView)
            let adjustedFrame = activeFrame.insetBy(dx: 0, dy: -20)
            scrollView.scrollRectToVisible(adjustedFrame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func closeModal() {
        dismiss(animated: true)
    }
}

// MARK: - FoodGalleryViewDelegate
extension AddFoodController: FoodGalleryViewDelegate {
    func foodGalleryView(_ view: FoodGalleryView, didDeleteFoodAt index: Int) {
        let deletedFood = foods[index]
        
        // 해당 음식의 라벨 제거
        imageSectionView.removeDetectionLabel(for: deletedFood.name)
        foodOptionView.clearSelection(for: deletedFood.name)
        
        // 음식 이름으로 칼로리 삭제
        selectedFoodCalories.removeValue(forKey: deletedFood.name)
        
        foods.remove(at: index)
        foodGalleryView.configure(with: foods)
        
        // 총 칼로리 업데이트
        totalCalories = selectedFoodCalories.values.reduce(0, +)
        
        if let selectedIndex = foodGalleryView.selectedFoodIndex,
           selectedIndex == index {
            isShowingOptions = false
        }
    }
    
    func foodGalleryView(_ view: FoodGalleryView, didSelectFoodAt index: Int) {
        if index == -1 {
            isShowingOptions = false
        } else {
            isShowingOptions = true
            let selectedFood = foods[index]
            foodOptionView.configure(
                for: selectedFood.name,
                customCalorie: selectedFood.baseCalorie
            )
        }
    }
    
    func foodGalleryViewDidTapAddButton(_ view: FoodGalleryView) {
        let directAddVC = directAddFood()
        directAddVC.delegate = self
        navigationController?.pushViewController(directAddVC, animated: true)
    }
}

// MARK: - FoodOptionViewDelegate
extension AddFoodController: FoodOptionViewDelegate {
    func foodOptionView(_ view: FoodOptionView, didSelectAmount amount: Int, calories: Int) {
            guard let selectedIndex = foodGalleryView.selectedFoodIndex else { return }
            
            // 선택된 음식 업데이트
            var updatedFood = foods[selectedIndex]
            updatedFood.selectedAmount = String(amount)
            updatedFood.selectedCalorie = calories
            foods[selectedIndex] = updatedFood
            
            // 선택된 음식의 칼로리 업데이트 - 이름을 키로 사용
            selectedFoodCalories[updatedFood.name] = calories
            
            // 전체 칼로리 다시 계산
            totalCalories = selectedFoodCalories.values.reduce(0, +)
        }
}

// MARK: - MealTimeSelectionViewDelegate
extension AddFoodController: MealTimeSelectionViewDelegate {
    func mealTimeSelectionView(_ view: MealTimeSelectionView, didSelect mealTime: MealTime) {
        print("Selected meal time: \(mealTime)")
    }
}

// MARK: - ShareOptionViewDelegate
extension AddFoodController: ShareOptionViewDelegate {
    func shareOptionView(_ view: ShareOptionView, didChangeShareStatus isSharing: Bool) {
        if isSharing && hasInappropriateContent {
            // 알림창 표시
            let alert = UIAlertController(
                title: "공유 불가",
                message: "이미지에 부적절한 콘텐츠가 있습니다.",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                // 토글 버튼을 false로 되돌림
                self?.shareOptionView.setShareStatus(false)
            }
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
    }
}

// MARK: - DirectAddFoodDelegate
extension AddFoodController: DirectAddFoodDelegate {
    func didAddNewFood(name: String, calorie: Int) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let grayImage = renderer.image { context in
            UIColor.lightGray.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        let newFood = Food(
                    image: grayImage,
                    name: name,
                    type: .custom,
                    baseCalorie: calorie,
                    selectedAmount: "1인분",
                    selectedCalorie: calorie
                )
                
                foods.append(newFood)
                selectedFoodCalories[name] = calorie // 이름으로 칼로리 저장
                
                totalCalories = selectedFoodCalories.values.reduce(0, +)
                foodGalleryView.configure(with: foods)
            }
}

extension AddFoodController {
    func processSelectedImage(_ image: UIImage) {
        // 이미지 설정
        imageSectionView.configure(with: image, calories: 0)
        
        // 음식과 부적절한 콘텐츠 감지 시작
        processImage(image)
    }
    
//    private func processDetections(for request: VNRequest, error: Error?, originalImage: UIImage) {
//        guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }
//        
//        let validDetections = observations.filter { $0.confidence >= 0.5 }
//        var uniqueDetections: [String: VNRecognizedObjectObservation] = [:]
//        
//        // confidence가 가장 높은 것만 저장
//        for observation in validDetections {
//            guard let firstLabel = observation.labels.first?.identifier else { continue }
//            let foodName = firstLabel
//            
//            if let existingObs = uniqueDetections[foodName] {
//                if observation.confidence > existingObs.confidence {
//                    uniqueDetections[foodName] = observation
//                }
//            } else {
//                uniqueDetections[foodName] = observation
//            }
//        }
//        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            // Food 객체 생성
//            let detectedFoods = uniqueDetections.values.compactMap { observation -> Food? in
//                guard let label = observation.labels.first else { return nil }
//                let foodName = label.identifier
//                
//                // 정확한 이미지 크롭을 위해 좌표 변환
//                let normalizedRect = self.normalizedRect(for: observation.boundingBox,
//                                                       originalImage: originalImage)
//                let croppedImage = self.cropImage(originalImage, for: normalizedRect)
//                let foodType = self.getFoodType(from: foodName)
//                
//                let baseCalorie = FoodCalorieManager.shared.getCalorie(for: foodName)
//                self.selectedFoodCalories[foodName] = baseCalorie
//                
//                return Food(
//                    image: croppedImage,
//                    name: foodName,
//                    type: foodType,
//                    baseCalorie: baseCalorie,
//                    selectedAmount: "1인분",
//                    selectedCalorie: baseCalorie
//                )
//            }
//            
//            self.foods = detectedFoods
//            self.totalCalories = self.selectedFoodCalories.values.reduce(0, +)
//            
//            // UI 업데이트
//            self.imageSectionView.configure(with: originalImage, calories: self.totalCalories)
//            self.foodGalleryView.configure(with: self.foods)
//            
//            // 바운딩 박스 업데이트
//            self.imageSectionView.updateDetections(Array(uniqueDetections.values))
//        }
//    }
    
    private func processDetections(for request: VNRequest, error: Error?, originalImage: UIImage) {
       guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }
       
       let validDetections = observations.filter { observation -> Bool in
           guard let label = observation.labels.first?.identifier else { return false }
           
           // 김치, 김치찌개, 쌀밥은 85% 이상일 때만 감지
           if ["김치", "김치찌개", "쌀밥"].contains(label) {
               return observation.confidence >= 0.85
           }
           // 나머지는 기존대로 50% 이상
           return observation.confidence >= 0.5
       }
       
       var uniqueDetections: [String: VNRecognizedObjectObservation] = [:]
       
       // confidence가 가장 높은 것만 저장하면서 즉시 칼로리 계산
       for observation in validDetections {
           guard let firstLabel = observation.labels.first?.identifier else { continue }
           let foodName = firstLabel
           
           if let existingObs = uniqueDetections[foodName] {
               if observation.confidence > existingObs.confidence {
                   uniqueDetections[foodName] = observation
                   // 기존 음식의 칼로리 업데이트
                   let baseCalorie = FoodCalorieManager.shared.getCalorie(for: foodName)
                   selectedFoodCalories[foodName] = baseCalorie
               }
           } else {
               uniqueDetections[foodName] = observation
               // 새로운 음식이 감지될 때 즉시 칼로리 추가
               let baseCalorie = FoodCalorieManager.shared.getCalorie(for: foodName)
               selectedFoodCalories[foodName] = baseCalorie
           }
       }
       
       // 총 칼로리 즉시 계산
       totalCalories = selectedFoodCalories.values.reduce(0, +)
       
       DispatchQueue.main.async { [weak self] in
           guard let self = self else { return }
           
           // UI 업데이트를 먼저 수행
           self.imageSectionView.configure(with: originalImage, calories: self.totalCalories)
           
           // 나머지 Food 객체 생성 및 UI 업데이트
           let detectedFoods = uniqueDetections.values.compactMap { observation -> Food? in
               guard let label = observation.labels.first else { return nil }
               let foodName = label.identifier
               
               let normalizedRect = self.normalizedRect(for: observation.boundingBox,
                                                      originalImage: originalImage)
               let croppedImage = self.cropImage(originalImage, for: normalizedRect)
               let foodType = self.getFoodType(from: foodName)
               
               let baseCalorie = FoodCalorieManager.shared.getCalorie(for: foodName)
               
               return Food(
                   image: croppedImage,
                   name: foodName,
                   type: foodType,
                   baseCalorie: baseCalorie,
                   selectedAmount: "1인분",
                   selectedCalorie: baseCalorie
               )
           }
           
           self.foods = detectedFoods
           self.foodGalleryView.configure(with: self.foods)
           
           // VNRecognizedObjectObservation을 FoodDetection으로 변환
           let foodDetections = uniqueDetections.values.map { observation -> FoodDetection in
               let label = observation.labels.first?.identifier ?? ""
               return FoodDetection(
                   label: label,
                   confidence: observation.confidence,
                   boundingBox: observation.boundingBox,
                   modelType: .general
               )
           }
           
           // 바운딩 박스 업데이트
           self.imageSectionView.updateDetections(foodDetections)
       }
    }
    
    private func normalizedRect(for boundingBox: CGRect, originalImage: UIImage) -> CGRect {
        // Vision 프레임워크의 좌표계(왼쪽 하단 원점)를
        // UIKit 좌표계(왼쪽 상단 원점)로 변환
        let x = boundingBox.minX
        let y = 1 - boundingBox.maxY  // y 좌표 변환
        let width = boundingBox.width
        let height = boundingBox.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func cropImage(_ image: UIImage, for normalizedRect: CGRect) -> UIImage {
        let imageSize = image.size
        
        // 정규화된 좌표를 실제 이미지 픽셀 좌표로 변환
        let x = normalizedRect.minX * imageSize.width
        let y = normalizedRect.minY * imageSize.height
        let width = normalizedRect.width * imageSize.width
        let height = normalizedRect.height * imageSize.height
        
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        if let cgImage = image.cgImage,
           let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage)
        }
        
        return image
    }
    
    private func getFoodType(from label: String) -> FoodType {
        // 라벨에 따라 적절한 FoodType 반환
        switch label.lowercased() {
        case "rice": return .rice
        case "soup": return .soup
        case "pasta": return .pasta
            // 다른 케이스들 추가...
        default: return .custom
        }
    }
    
//    private func detectFoods(in image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//        
//        do {
//            let config = MLModelConfiguration()
//            let model = try best_2(configuration: config).model
//            let visionModel = try VNCoreMLModel(for: model)
//            
//            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
//                self?.processDetections(for: request, error: error, originalImage: image)
//            }
//            request.imageCropAndScaleOption = .scaleFit
//            
//            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//            try handler.perform([request])
//            
//        } catch {
//            print("Detection error:", error)
//        }
//    }
    
    private func detectFoods(in image: UIImage) {
            FoodDetectionManager.shared.detectFood(in: image) { [weak self] detections in
                guard let self = self else { return }
                
                // Food 객체 생성
                let detectedFoods = detections.compactMap { detection -> Food? in
                    // 정확한 이미지 크롭을 위해 좌표 변환
                    let normalizedRect = self.normalizedRect(for: detection.boundingBox,
                                                           originalImage: image)
                    let croppedImage = self.cropImage(image, for: normalizedRect)
                    let foodType = self.getFoodType(from: detection.label)
                    
                    let baseCalorie = FoodCalorieManager.shared.getCalorie(for: detection.label)
                    self.selectedFoodCalories[detection.label] = baseCalorie
                    
                    return Food(
                        image: croppedImage,
                        name: detection.label,
                        type: foodType,
                        baseCalorie: baseCalorie,
                        selectedAmount: "1인분",
                        selectedCalorie: baseCalorie
                    )
                }
                
                self.foods = detectedFoods
                self.totalCalories = self.selectedFoodCalories.values.reduce(0, +)
                
                // UI 업데이트
                self.imageSectionView.configure(with: image, calories: self.totalCalories)
                self.foodGalleryView.configure(with: self.foods)
                
                // 바운딩 박스와 라벨 업데이트
                self.imageSectionView.updateDetections(detections)
            }
        }
}

extension AddFoodController: AddButtonViewDelegate {
    
        func addButtonViewDidTapAdd(_ view: AddButtonView) {
            // 데이터 검증
            guard let selectedTime = mealTimeSelectionView.getSelectedTime() else {
                showAlert(message: "식사 시간을 선택해주세요")
                return
            }
            
            guard !foodContentView.title.isEmpty else {
                showAlert(message: "제목을 입력해주세요")
                return
            }
            
            guard let image = imageSectionView.imageView.image else {
                showAlert(message: "이미지가 필요합니다")
                return
            }
            
            // 업로드 시작
            Task {
                do {
                    showLoadingIndicator()
                    
                    try await FoodPostManager.shared.uploadFoodPost(
                        title: foodContentView.title,
                        image: image,
                        description: foodContentView.content,
                        foods: foods,
                        totalCalories: totalCalories,
                        mealTime: selectedTime,
                        isShared: shareOptionView.getShareStatus()
                    )
                    
                    hideLoadingIndicator()
                    dismiss(animated: true)
                    
                } catch {
                    hideLoadingIndicator()
                    showAlert(message: "업로드 실패: \(error.localizedDescription)")
                
            }
        }
    }

}

extension AddFoodController {
    private func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tag = 999
        activityIndicator.center = view.center
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
    }
    
    private func hideLoadingIndicator() {
        if let activityIndicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
// MARK: - Helper Structures
struct FoodData {
    let title: String
    let content: String
    let mealTime: MealTime
    let calories: Int
    let isShared: Bool
}
