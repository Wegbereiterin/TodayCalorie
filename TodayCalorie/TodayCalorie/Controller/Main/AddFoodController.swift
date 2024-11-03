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
    private lazy var selectedFoodCalories: [Int: Int] = [:]
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
        
        let validDetections = observations.filter { $0.confidence >= 0.6 }
        
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
        
        foods.remove(at: index)
        foodGalleryView.configure(with: foods)
        
        // 남은 음식들의 총 칼로리 계산
        let remainingCalories = foods.reduce(0) { sum, food in
            return sum + FoodCalorieManager.shared.getCalorie(for: food.name)
        }
        imageSectionView.configure(with: imageSectionView.imageView.image, calories: remainingCalories)
        
        if let selectedIndex = foodGalleryView.selectedFoodIndex,
           selectedIndex == index {
            isShowingOptions = false
        }
        
        selectedFoodCalories.removeValue(forKey: index)
        totalCalories = selectedFoodCalories.values.reduce(0, +)
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
        
        // 선택된 음식의 칼로리 업데이트
        selectedFoodCalories[selectedIndex] = calories
        
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

// MARK: - AddButtonViewDelegate
//extension AddFoodController: AddButtonViewDelegate {
//    func addButtonViewDidTapAdd(_ view: AddButtonView) {
//        // 데이터 검증
//        guard let selectedTime = mealTimeSelectionView.getSelectedTime() else {
//            // 알림: 식사 시간을 선택해주세요
//            return
//        }
//        
//        guard !foodContentView.title.isEmpty else {
//            // 알림: 제목을 입력해주세요
//            return
//        }
//        
//        // 데이터 저장 및 처리
//        let data = FoodData(
//            title: foodContentView.title,
//            content: foodContentView.content,
//            mealTime: selectedTime,
//            calories: totalCalories,
//            isShared: shareOptionView.getShareStatus()
//        )
//        
//        saveFoodData(data)
//    }
//    
//    private func saveFoodData(_ data: FoodData) {
//        print("Saving food data:", data)
//        navigationController?.popViewController(animated: true)
//    }
//}

// MARK: - DirectAddFoodDelegate
extension AddFoodController: DirectAddFoodDelegate {
    func didAddNewFood(name: String, calorie: Int) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let grayImage = renderer.image { context in
            UIColor.lightGray.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        let newFood = Food(image: grayImage, name: name, type: .custom, baseCalorie: calorie)
        foods.append(newFood)
        
        // 추가된 음식의 인덱스를 계산
        let newIndex = foods.count - 1
        selectedFoodCalories[newIndex] = calorie
        totalCalories = selectedFoodCalories.values.reduce(0, +)
        
        foodGalleryView.configure(with: foods)
    }
}

// MARK: - Image Processing
extension AddFoodController {
    func processSelectedImage(_ image: UIImage) {
        // 이미지 설정
        imageSectionView.configure(with: image, calories: 0)
        
        // 음식과 부적절한 콘텐츠 감지 시작
        processImage(image)
    }
    
    private func detectFoods(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        do {
            let config = MLModelConfiguration()
            let model = try best_2(configuration: config).model
            let visionModel = try VNCoreMLModel(for: model)
            
            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.processDetections(for: request, error: error, originalImage: image)
            }
            request.imageCropAndScaleOption = .scaleFit
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
            
        } catch {
            print("Detection error:", error)
        }
    }
    
    private func processDetections(for request: VNRequest, error: Error?, originalImage: UIImage) {
       guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }
       
       // 신뢰도가 높은 감지 결과만 필터링
       let validDetections = observations.filter { $0.confidence >= 0.5 }
       
       // 중복 제거를 위한 Dictionary
       var uniqueDetections: [String: VNRecognizedObjectObservation] = [:]
       
       // confidence가 가장 높은 것만 저장
       for observation in validDetections {
           guard let firstLabel = observation.labels.first?.identifier else { continue }
           let foodName = firstLabel
           
           if let existingObs = uniqueDetections[foodName] {
               if observation.confidence > existingObs.confidence {
                   uniqueDetections[foodName] = observation
               }
           } else {
               uniqueDetections[foodName] = observation
           }
       }
       
       // 총 칼로리 계산 (고유한 음식 각각에 대해)
       let totalCalories = uniqueDetections.values.reduce(0) { sum, observation in
           guard let label = observation.labels.first else { return sum }
           return sum + FoodCalorieManager.shared.getCalorie(for: label.identifier)
       }
       
       DispatchQueue.main.async { [weak self] in
           guard let self = self else { return }
           
           // 이미지 설정과 레이아웃을 강제로 업데이트
           self.imageSectionView.configure(with: originalImage, calories: totalCalories)
           self.view.layoutIfNeeded()
           
           // 약간의 지연을 주어 레이아웃이 완전히 적용된 후 레이블 추가
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               // 라벨 업데이트
               self.imageSectionView.updateDetections(Array(uniqueDetections.values))
           }
           
           // Food 객체 생성 및 컬렉션뷰 업데이트
           let detectedFoods = uniqueDetections.values.compactMap { observation -> Food? in
               guard let label = observation.labels.first else { return nil }
               let croppedImage = self.cropImage(originalImage, for: observation.boundingBox)
               let foodType = self.getFoodType(from: label.identifier)
               
               // 과일 종류에 따른 기본 칼로리 설정
               let baseCalorie = FoodCalorieManager.shared.getCalorie(for: label.identifier)
               
               return Food(
                   image: croppedImage,
                   name: label.identifier,
                   type: foodType,
                   baseCalorie: baseCalorie
               )
           }
           
           self.foods = detectedFoods
           self.foodGalleryView.configure(with: detectedFoods)
       }
    }
    
    private func clearDetectionBoxes() {
        detectionBoxes.forEach { $0.removeFromSuperview() }
        detectionBoxes.removeAll()
    }
    
    private func cropImage(_ image: UIImage, for boundingBox: CGRect) -> UIImage {
        let imageSize = image.size
        let x = boundingBox.minX * imageSize.width
        let y = (1 - boundingBox.maxY) * imageSize.height
        let width = boundingBox.width * imageSize.width
        let height = boundingBox.height * imageSize.height
        
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        if let cgImage = image.cgImage,
           let croppedCGImage = cgImage.cropping(to: cropRect) {
            let croppedImage = UIImage(cgImage: croppedCGImage)
            return croppedImage
        }
        
        // 크롭 실패시 원본 이미지의 해당 부분을 그대로 사용
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
}

extension AddFoodController: AddButtonViewDelegate {
//    private func saveFoodPost() async {
//            guard let image = imageSectionView.imageView.image else { return }
//            
//            showLoadingIndicator()
//            
//            do {
//                try await FoodPostManager.shared.uploadFoodPost(
//                    title: foodContentView.title,
//                    image: image,
//                    description: foodContentView.content,
//                    foods: foods,
//                    totalCalories: totalCalories,
//                    mealTime: mealTimeSelectionView.getSelectedTime() ?? .morning,
//                    isShared: shareOptionView.getShareStatus()
//                )
//                
//                hideLoadingIndicator()
//                dismiss(animated: true)
//                
//            } catch {
//                hideLoadingIndicator()
//                showAlert(message: "DEBUG: 업로드에 실패했습니다: \(error.localizedDescription)")
//            }
//        }
    
    // 저장 버튼 탭 시
//        func addButtonViewDidTapAdd(_ view: AddButtonView) {
//            // 데이터 검증
//            guard let selectedTime = mealTimeSelectionView.getSelectedTime() else {
//                showAlert(message: "식사 시간을 선택해주세요")
//                return
//            }
//            
//            guard !foodContentView.title.isEmpty else {
//                showAlert(message: "제목을 입력해주세요")
//                return
//            }
//            
//            // 이미지가 있는지 확인
//            guard let image = imageSectionView.imageView.image else {
//                showAlert(message: "이미지가 필요합니다")
//                return
//            }
//            
//            // Task를 사용하여 비동기 작업 처리
//            Task {
//                do {
//                    // 로딩 표시
//                    showLoadingIndicator()
//                    print("DEBUG: 이미지? = \(image)")
//                    try await FoodPostManager.shared.uploadFoodPost(
//                        title: foodContentView.title,
//                        image: image,
//                        description: foodContentView.content,
//                        foods: foods,
//                        totalCalories: totalCalories,
//                        mealTime: selectedTime,
//                        isShared: shareOptionView.getShareStatus()
//                    )
//                    
//                    // 로딩 숨김
//                    hideLoadingIndicator()
//                    // 성공시 화면 닫기
//                    dismiss(animated: true)
//                    
//                } catch {
//                    // 에러 처리
//                    hideLoadingIndicator()
//                    showAlert(message: "DEBUG: 업로드에 실패했습니다: \(error.localizedDescription)")
//                }
//            }
//        }
    
    func addButtonViewDidTapAdd(_ view: AddButtonView) {
            guard let image = imageSectionView.imageView.image else {
                showAlert(message: "이미지가 필요합니다")
                return
            }
            
            // 테스트 업로드
            Task {
                do {
                    showLoadingIndicator()
                    let path = try await FoodPostManager.shared.testImageUpload(image)
                    print("DEBUG: 업로드 성공. 파일명: \(path)")
                    hideLoadingIndicator()
                } catch {
                    hideLoadingIndicator()
                    showAlert(message: "업로드 실패: \(error.localizedDescription)")
                    print("DEBUG: 업로드 에러: \(error)")
                }
            }
        }

}

extension AddFoodController {
    private func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tag = 999
        activityIndicator.center = view.center
        activityIndicator.color = .gray
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
