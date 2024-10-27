//
//  ClassificationViewController.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/26/24.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ClassificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private var calorieInfo: [String: Int] = [:]
    private var selectedIndex: IndexPath?
    
    struct FoodItem {
        let name: String
        let calories: String
    }
    
    private var foodItems: [FoodItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var foodName: String?
    var foodCalorie: Int?
    
    var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                imageView.image = image
                updateClassifications(for: image)
            }
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "FoodCell")
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 66
        
        view.isScrollEnabled = false
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .main
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let checkButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let config = MLModelConfiguration()
            let model = try FoodClassifier(configuration: config).model
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNavigationBar()
        loadCalorieInfo()
    }
    
    // MARK: - Selectors
    
    @objc func closeModal() {
        dismiss(animated: true)
    }
    
    @objc func checkButtonTapped() {
        if let selectedIndex = selectedIndex {
            let selectedItem = foodItems[selectedIndex.row]
            foodName = selectedItem.name
            if !selectedItem.calories.isEmpty {
                foodCalorie = Int(selectedItem.calories)
            }

            print("Selected food: \(foodName ?? ""), calories: \(foodCalorie ?? 0)")
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(tableView)
        view.addSubview(checkButtonContainer)
        checkButtonContainer.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor), // 정사각형
            
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: checkButtonContainer.topAnchor),
            
            checkButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            checkButtonContainer.heightAnchor.constraint(equalToConstant: 70),
            
            checkButton.topAnchor.constraint(equalTo: checkButtonContainer.topAnchor, constant: 5),
            checkButton.leadingAnchor.constraint(equalTo: checkButtonContainer.leadingAnchor, constant: 16),
            checkButton.trailingAnchor.constraint(equalTo: checkButtonContainer.trailingAnchor, constant: -16),
            checkButton.bottomAnchor.constraint(equalTo: checkButtonContainer.bottomAnchor, constant: -5),
            checkButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Classification"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeModal))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func loadCalorieInfo() {
        do {
            let config = MLModelConfiguration()
            let model = try FoodClassifier(configuration: config)
            
            print("Loading calorie info...")
            
            if let creatorDefinedKey = model.model.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String],
               let calorieInfoString = creatorDefinedKey["calorie_info"] {
                print("Found calorie info string: \(calorieInfoString)")
                
                if let data = calorieInfoString.data(using: .utf8) {
                    calorieInfo = try JSONDecoder().decode([String: Int].self, from: data)
                    print("Successfully loaded calorie info:")
                    calorieInfo.forEach { key, value in
                        print("  \(key): \(value)")
                    }
                } else {
                    print("Failed to convert calorie info string to data")
                }
            } else {
                print("No calorie info found in model metadata")
            }
        } catch {
            print("Error loading calorie info: \(error)")
        }
    }
    
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image)") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification: \(error)")
            }
        }
    }
    
    func findCalories(for identifier: String) -> Int {
        let normalizedIdentifier = identifier.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Searching calories for identifier: \(normalizedIdentifier)")
        print("Available calorie info keys: \(calorieInfo.keys)")
        
        if let calories = calorieInfo[normalizedIdentifier] {
            print("Found exact match: \(calories)")
            return calories
        }
        
        let fruitKey = normalizedIdentifier + " fruit"
        if let calories = calorieInfo[fruitKey] {
            print("Found match with fruit suffix: \(calories)")
            return calories
        }
        
        for (key, value) in calorieInfo {
            let normalizedKey = key.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if normalizedKey.contains(normalizedIdentifier) || normalizedIdentifier.contains(normalizedKey) {
                print("Found partial match: \(value) for key: \(key)")
                return value
            }
        }
        
        print("No calorie information found for: \(normalizedIdentifier)")
        return 0
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.foodItems = [
                    FoodItem(name: "이미지 분석 실패", calories: ""),
                    FoodItem(name: "이미지 분석 실패", calories: ""),
                    FoodItem(name: "직접입력", calories: "")
                ]
                return
            }
            
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.foodItems = [
                    FoodItem(name: "인식된 결과 없음", calories: ""),
                    FoodItem(name: "인식된 결과 없음", calories: ""),
                    FoodItem(name: "직접입력", calories: "")
                ]
            } else {
                var items: [FoodItem] = []
                let topClassifications = Array(classifications.prefix(2))
                
                for classification in topClassifications {
                    let calories = self.findCalories(for: classification.identifier)
                    items.append(FoodItem(name: classification.identifier,
                                          calories: String(calories)))
                }
                
                items.append(FoodItem(name: "직접입력", calories: ""))
                self.foodItems = items
            }
        }
    }
}

extension ClassificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        let item = foodItems[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.gray.cgColor
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])
        
        containerView.backgroundColor = indexPath == selectedIndex ? .main : .white
        
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let calorieLabel = UILabel()
        calorieLabel.text = item.calories.isEmpty ? "" : "\(item.calories)Kcal"
        calorieLabel.font = .systemFont(ofSize: 16)
        calorieLabel.textColor = .black
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(calorieLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            calorieLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            calorieLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.reloadData()
        
        let selectedItem = foodItems[indexPath.row]
        foodName = selectedItem.name
        if !selectedItem.calories.isEmpty {
            foodCalorie = Int(selectedItem.calories)
        }
    }
}
