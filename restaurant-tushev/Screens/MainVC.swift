//
//  MainVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit
import SnapKit

final class MainVC: UIViewController {
    
    private let menuSerivece = MenuService()
    
    private var menuData: [MenuSection] = []
    
    let collectionView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNewLogin()
        configure()
        makeConstraints()
        getMenu()
    }
    
    private func setupSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func searchButtonTapped() {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func checkNewLogin() {
        guard let _ = UserDefaults.standard.string(forKey: "authVerificationID") else {
            let authVC = AuthenticationVC(nibName: nil, bundle: nil)
            authVC.modalPresentationStyle = .overFullScreen
            self.present(authVC, animated: false)
            return
        }
    }
    
    private func configure() {
        setupSearchButton()
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
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
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
        
        return cell
    }
}
