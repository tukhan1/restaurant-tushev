//
//  MainVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

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
        pageControl.isUserInteractionEnabled = false
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
    
    private lazy var bookingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Бронировать столик", for: .normal)
        button.backgroundColor = .lightBrown
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let loyaltyView: LoyaltyView = LoyaltyView(frame: .zero)
    
    convenience init(recommendations: [MasterClass], banners: [Banner], loyaltyPoints: Double) {
        self.init()
        self.chefRecommendations = recommendations
        self.banners = banners
        loyaltyView.setAmount(loyaltyPoints)
        chefRecommendationTableView.reloadData()
        bannerCollectionView.reloadData()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        fetchBanners()
//        fetchChefRecommendations()
//        fetchLoyalty()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Главная"
        
        view.addSubview(scrollView)
        scrollView.addSubviews(bannerCollectionView, pageControl, loyaltyView,bookingButton, chefRecommendationTableView)
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
        loyaltyView.snp.makeConstraints { make in
            make.top.equalTo(bannerCollectionView.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(100)
        }
        bookingButton.snp.makeConstraints { make in
            make.top.equalTo(loyaltyView.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
        
        chefRecommendationTableView.snp.makeConstraints { make in
            make.top.equalTo(bookingButton.snp.bottom).offset(10)
            make.left.right.equalTo(view)
            make.height.equalTo(150)
        }
    }
    
    private func updateTableViewHeight() {
        let height = chefRecommendations.count * 150 // Высота всех ячеек
        chefRecommendationTableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        // Обновите contentSize scrollView, если он зависит от высоты tableView
        scrollView.contentSize = CGSize(width: view.frame.width, height: bannerCollectionView.frame.height + loyaltyView.frame.height + bookingButton.frame.height + CGFloat(height) + 40)
        view.layoutIfNeeded()
    }
    
    @objc private func bookingButtonTapped() {
        // Открыть экран бронирования
        let bookingVC = BookingVC()
        navigationController?.pushViewController(bookingVC, animated: true)
    }
    
    // MARK: - Data Fetching
    private func fetchBanners() {
        RestaurantService.shared.fetchBanners { result in
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
        RestaurantService.shared.fetchChefRecommendations { result in
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
    
    // Автоматическая Регистрация при Создании Аккаунта
    private func fetchLoyalty() {
        UserService.shared.fetchLoyaltyData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loyaltyCard):
                DispatchQueue.main.async { self.loyaltyView.setAmount(loyaltyCard.amount) }
            case .failure(let error):
                print(error)
            }
        }
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = banners[indexPath.item]
        self.present(PromoDitailsVC(banner: banner), animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let recommendation = chefRecommendations[indexPath.row]
        guard let url = URL(string: recommendation.recipeUrl ?? "") else { return }
        let webVC = WebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
}
