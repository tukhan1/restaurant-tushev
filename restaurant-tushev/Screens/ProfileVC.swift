//
//  ProfileVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit
import SnapKit

class ProfileVC: UIViewController {
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 // Радиус для круглой картинки
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray // Заглушка для изображения
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(nil, action: #selector(logoutAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadUserProfile()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = "Профиль"
        
        view.addSubviews(profileImageView, nameLabel, emailLabel, logoutButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(30)
            make.left.right.equalTo(view).inset(50)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    @objc private func logoutAction() {
        // Здесь будет логика для выхода из учетной записи
        print("Пользователь вышел из учетной записи")
    }
    
    // MARK: - Data Loading
    private func loadUserProfile() {
        // Здесь будет код для загрузки данных профиля пользователя
        // Для примера установим заглушки
        nameLabel.text = "Иван Иванов"
        emailLabel.text = "ivan@example.com"
    }
}
