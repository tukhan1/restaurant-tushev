//
//  MainVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit
import SnapKit

final class OrderVC: UIViewController {
    
    private var cartManager = CartManager()
    private var menuData: [MenuSection] = []
    
    private let miniCartView = MiniCartView()
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
        collectionView.reloadData()
    }
    
    private func getMenu() {
        RestaurantService.shared.getFullMenu { result in
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        view.addSubviews(collectionView, miniCartView)
        miniCartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentCart)))
    }
    
    @objc private func presentCart() {
        let cartVC = CartVC(cartManager: cartManager)
        cartVC.delegate = self
        navigationController?.pushViewController(cartVC, animated: true)
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

        if let cartItem = cartManager.items.first(where: { $0.product == product }) {
            cell.tapCounter = cartItem.quantity
            cell.setCell(for: product)
        } else {
            cell.tapCounter = 0
            cell.setCell(for: product)
        }

        cell.addToCartAction = {
            self.addToCart(product: product)
        }
        cell.removeFromCartAction = {
            self.removeFromCart(product: product)
        }
        return cell
    }
    
    private func addToCart(product: Product) {
        cartManager.addToCart(product)
        updateMiniCartView()
    }
    
    private func removeFromCart(product: Product) {
        cartManager.removeFromCart(product)
        updateMiniCartView()
    }
}

extension OrderVC: CartVCDelegate {
    func cartVCWillDeinit(cartManager: CartManager) {
        self.cartManager = cartManager
        collectionView.reloadData()
    }
}
