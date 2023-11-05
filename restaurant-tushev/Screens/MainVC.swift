//
//  MainVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    // MARK: - Properties
    private var banners: [Banner] = [] // Модель данных для баннеров
    private var chefRecommendations: [MasterClass] = [] // Модель данных для рекомендаций шефа
    private var loyaltyPoints: Int = 0 // Бонусные баллы пользователя
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = banners.count
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: 200)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var chefRecommendationTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ChefRecommendationCell.self, forCellReuseIdentifier: "ChefRecommendationCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var loyaltyPointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Бонусные баллы: \(loyaltyPoints)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchBanners()
        fetchChefRecommendations()
        fetchLoyaltyPoints()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Главная"
        
        view.addSubview(scrollView)
        scrollView.addSubviews(bannerCollectionView, pageControl, loyaltyPointsLabel, chefRecommendationTableView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        bannerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.left.right.equalTo(view)
            make.height.equalTo(200)
            make.width.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(bannerCollectionView.snp.bottom).offset(-5)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        loyaltyPointsLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerCollectionView.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        
        chefRecommendationTableView.snp.makeConstraints { make in
            make.top.equalTo(loyaltyPointsLabel.snp.bottom).offset(10)
            make.left.right.equalTo(view)
            make.height.equalTo(150)
        }
        
        // Убедитесь, что scrollView может прокручиваться, если содержимое больше его высоты
//        scrollView.contentSize = CGSize(width: view.frame.width, height: 200 + 50 + CGFloat(chefRecommendations.count * 150) + 20)
    }
    
    // MARK: - Data Fetching
    private func fetchBanners() {
        MenuService.shared.fetchBanners { result in
            switch result {
            case .success(let banners):
                DispatchQueue.main.async {
                    self.banners = banners
                    self.pageControl.numberOfPages = banners.count
                    self.bannerCollectionView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func fetchChefRecommendations() {
        MenuService.shared.fetchChefRecommendations { result in
            switch result {
            case .success(let chefRecommendations):
                DispatchQueue.main.async {
                    self.chefRecommendations = chefRecommendations
                    self.chefRecommendationTableView.reloadData()
                    self.updateTableViewHeight()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func fetchLoyaltyPoints() {
        // Здесь будет код для получения бонусных баллов пользователя
    }
    
    private func updateTableViewHeight() {
        let height = chefRecommendations.count * 150 // Высота всех ячеек
        chefRecommendationTableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        // Обновите contentSize scrollView, если он зависит от высоты tableView
        scrollView.contentSize = CGSize(width: view.frame.width, height: bannerCollectionView.frame.height + loyaltyPointsLabel.frame.height + CGFloat(height) + 20)
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        let banner = banners[indexPath.item]
        cell.configure(with: banner)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chefRecommendations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefRecommendationCell", for: indexPath) as! ChefRecommendationCell
        let recommendation = chefRecommendations[indexPath.row]
        cell.configure(with: recommendation)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
