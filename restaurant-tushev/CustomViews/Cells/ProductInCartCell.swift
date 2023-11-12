//
//  ProductInCartCell.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductInCartCell: UITableViewCell, ReusableView {
    private let productImageView = UIImageView(frame: .zero)
    private let productNameLabel = UILabel(frame: .zero)
    private let priceLabel = UILabel(frame: .zero)
    private let quantityLabel = UILabel(frame: .zero)
    
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
        contentView.addSubview(quantityLabel)
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
            make.right.equalTo(quantityLabel.snp.left)
            make.top.equalTo(productNameLabel.snp.bottom).offset(5)
        }
        quantityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(30)
        }
    }
    
    // Функция для конфигурации ячейки с данными
    func configure(with cartItem: CartItem) {
        downloadImage(fromUrl: cartItem.product.imageUrl)
        productNameLabel.text = cartItem.product.title
        priceLabel.text = "\(cartItem.product.cost) Р"
        quantityLabel.text = "\(cartItem.quantity)"
    }
    
    private func downloadImage(fromUrl url: String) {
        if let url = URL(string: url) {
            productImageView.kf.setImage(with: url)
        }
    }
}
