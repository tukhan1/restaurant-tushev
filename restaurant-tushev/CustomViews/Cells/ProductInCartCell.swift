//
//  ProductInCartCell.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit

final class ProductInCartCell: UITableViewCell, ReusableView {
    let productImageView = UIImageView()
    let productNameLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Настройка элементов UI
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Настройка внешнего вида элементов
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .gray
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 10
        productImageView.layer.masksToBounds = true
        
        // Добавление элементов на contentView
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(productImageView)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(productNameLabel.snp.bottom).offset(5)
        }
    }
    
    // Функция для конфигурации ячейки с данными
    func configure(with product: Product) {
        // Здесь должна быть логика загрузки изображения для productImageView
        productNameLabel.text = product.title
        priceLabel.text = "\(product.cost) Р"
        downloadImage(fromUrl: product.imageUrl)
    }
    
    private func downloadImage(fromUrl url: String) {
        ImageStorageManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.productImageView.image = image }
        }
    }
}
