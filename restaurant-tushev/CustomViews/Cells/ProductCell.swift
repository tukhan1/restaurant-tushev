//
//  CustomCollectionVIewCellCollectionViewCell.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit
import SnapKit

class ProductCell: UICollectionViewCell, ReusableView {
    
    var addToCartAction: (() -> Void)?
    var removeFromCartAction: (() -> Void)?
    var isInCart: Bool = false
    
    private var product: Product?

    private let productImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let productCostLabel = CustomLabel(font: .body, textAligment: .left)
    private let productTitleLabel = CustomLabel(font: .body, textAligment: .left)
    private let productWeightLabel = CustomLabel(font: .promt, textAligment: .left)
    private let buyButton: CustomButton = CustomButton(title: "В корзину",
                                                       background: UIColor(named: "clouds"))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCell(for product: Product) {
        self.product = product
        productCostLabel.text = product.cost + " Р"
        productTitleLabel.text = product.title
        productWeightLabel.text = product.weight + " g"
        updateCartButton(isInCart: isInCart)
        downloadImage(fromUrl: product.imageUrl)
    }

    private func downloadImage(fromUrl url: String) {
        ImageStorageManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.productImageView.image = image }
        }
    }

    private func configure() {
        contentView.addSubviews(productImageView, productCostLabel, productTitleLabel, productWeightLabel, buyButton)
        backgroundColor = UIColor(named: "silver")
        layer.cornerRadius = 15
        productTitleLabel.numberOfLines = 0
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
    }

    @objc private func buyButtonTapped() {
        if buyButton.currentTitle == "В корзину" {
                    addToCartAction?()
                } else {
                    removeFromCartAction?()
                }
    }
    
    func updateCartButton(isInCart: Bool) {
            if isInCart {
                buyButton.setTitle("Убрать", for: .normal)
            } else {
                buyButton.setTitle("В корзину", for: .normal)
            }
        }

    private func updateButtonUI(_ inCart: Bool) {
        inCart ? buyButton.setTitle("Убрать", for: .normal): buyButton.setTitle("Добавить", for: .normal)
        buyButton.backgroundColor = inCart ? .lightGray: UIColor(named: "clouds")
    }

    private func makeConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(6)
            make.left.equalTo(contentView.snp.left).offset(6)
            make.right.equalTo(contentView.snp.right).inset(6)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
        productCostLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).inset(10)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1)
        }
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(productCostLabel.snp.bottom)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).inset(10)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1)
        }
        productWeightLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).inset(10)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1)
        }
        buyButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(6)
            make.left.equalTo(contentView.snp.left).offset(6)
            make.right.equalTo(contentView.snp.right).inset(6)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.12)
        }
    }
}
