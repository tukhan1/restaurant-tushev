//
//  MainVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit
import SnapKit

final class OrderVC: UIViewController {
    
    private let cartManager = CartManager()
    
    private let miniCartView = MiniCartView()
    
    func addToCart(product: Product) {
        cartManager.addToCart(product)
        updateMiniCartView()
    }
    
    func removeFromCart(product: Product) {
        cartManager.removeFromCart(product)
        updateMiniCartView()
    }
    
    func presentCart() {
        print("lets go")
    }
    
    private let menuSerivece = MenuService()
    
    private var menuData: [MenuSection] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        layout.itemSize = UIHelper.createTwoColumn(in: UIScreen.main.bounds)
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductCell.self)
        return collectionView
    }()
    
    private func updateMiniCartView() {
        if cartManager.itemsCount > 0 {
            miniCartView.isHidden = false
        } else {
            miniCartView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeConstraints()
        getMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMiniCartView()
    }
    
    private func getMenu() {
        menuSerivece.getFullMenu { result in
            switch result {
            case .success(let menu):
                self.menuData = menu
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func configure() {
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubviews(collectionView, miniCartView)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        miniCartView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-5)
            make.height.width.equalTo(MiniCartSize.weightAndHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
    }
}

extension OrderVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        menuData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuData[section].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.titleLabel.text = menuData[indexPath.section].title
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
        let product = menuData[indexPath.section].products[indexPath.row]
        cell.setCell(for: product)
        cell.onBuyButtonTapped = { [weak self] in
            guard let self = self else { return }
                self.addToCart(product: product)
            }
        return cell
    }
}
