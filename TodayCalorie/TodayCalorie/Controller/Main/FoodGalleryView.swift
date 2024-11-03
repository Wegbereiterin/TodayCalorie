//
//  FoodGalleryView.swift
//  FlowerClassifierApp
//
//  Created by 박선구 on 11/2/24.
//

import UIKit

protocol FoodGalleryViewDelegate: AnyObject {
    func foodGalleryView(_ view: FoodGalleryView, didSelectFoodAt index: Int)
    func foodGalleryViewDidTapAddButton(_ view: FoodGalleryView)
    func foodGalleryView(_ view: FoodGalleryView, didDeleteFoodAt index: Int)
}

class FoodGalleryView: UIView {
    // MARK: - Properties
    weak var delegate: FoodGalleryViewDelegate?
    private var foods: [Food] = []
    var selectedFoodIndex: Int?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FoodCell.self, forCellWithReuseIdentifier: FoodCell.identifier)
        collectionView.register(AddCell.self, forCellWithReuseIdentifier: AddCell.identifier)
    }
    
    // MARK: - Public Methods
    func configure(with foods: [Food]) {
        self.foods = foods
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FoodGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == foods.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifier, for: indexPath) as! AddCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCell.identifier, for: indexPath) as! FoodCell
            let food = foods[indexPath.item]
            cell.configure(with: food.image, name: food.name)  // Food 구조체의 프로퍼티 사용
            cell.deleteAction = { [weak self] in
                self?.delegate?.foodGalleryView(self!, didDeleteFoodAt: indexPath.item)
            }
            cell.isSelectedCell = selectedFoodIndex == indexPath.item
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == foods.count {
            delegate?.foodGalleryViewDidTapAddButton(self)
        } else {
            if indexPath.item == selectedFoodIndex {
                // 같은 셀 다시 선택
                selectedFoodIndex = nil
                if let cell = collectionView.cellForItem(at: indexPath) as? FoodCell {
                    cell.isSelectedCell = false
                }
                delegate?.foodGalleryView(self, didSelectFoodAt: -1)
            } else {
                // 다른 셀 선택
                if let previousIndex = selectedFoodIndex,
                   let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? FoodCell {
                    previousCell.isSelectedCell = false
                }
                
                selectedFoodIndex = indexPath.item
                if let cell = collectionView.cellForItem(at: indexPath) as? FoodCell {
                    cell.isSelectedCell = true
                }
                delegate?.foodGalleryView(self, didSelectFoodAt: indexPath.item)
            }
        }
    }
}
