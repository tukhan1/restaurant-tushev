//
//  ProductCell.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 26.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductCell: UICollectionViewCell, ReusableView {
    
    var addToCartAction: (() -> Void)?
    var removeFromCartAction: (() -> Void)?
    
    var tapCounter: Int = 0

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
    private let buyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .lightBrown
        button.layer.cornerRadius = 17
        button.layer.shadowOpacity = 0.05
        return button
    }()
    private let counterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        return label
    }()
    private let plusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    private let minusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
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
        updateButtonUI()
        downloadImage(fromUrl: product.imageUrl)
    }

    private func downloadImage(fromUrl url: String) {
        if let url = URL(string: url) { productImageView.kf.setImage(with: url) }
    }

    private func configure() {
        contentView.addSubviews(productImageView, productCostLabel, productTitleLabel, productWeightLabel, buyButton)
        buyButton.addSubviews(counterLabel, plusButton, minusButton)
        backgroundColor = .mediumBrown
        layer.cornerRadius = 15
        productTitleLabel.numberOfLines = 0
        buyButton.addTarget(nil, action: #selector(buyButtonTapped), for: .touchUpInside)
        plusButton.addTarget(nil, action: #selector(increaseQuantity), for: .touchUpInside)
        minusButton.addTarget(nil, action: #selector(decreaseQuantity), for: .touchUpInside)
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
        counterLabel.snp.makeConstraints { make in
            make.top.equalTo(buyButton.snp.top)
            make.height.equalTo(buyButton.snp.height)
            make.left.equalTo(minusButton.snp.right)
            make.right.equalTo(plusButton.snp.left)
        }
        plusButton.snp.makeConstraints { make in
            make.right.equalTo(buyButton.snp.right)
            make.top.equalTo(buyButton.snp.top)
            make.width.equalTo(buyButton.snp.width).multipliedBy(0.2)
            make.height.equalTo(buyButton.snp.height)
        }
        minusButton.snp.makeConstraints { make in
            make.left.equalTo(buyButton.snp.left)
            make.top.equalTo(buyButton.snp.top)
            make.width.equalTo(buyButton.snp.width).multipliedBy(0.2)
            make.height.equalTo(buyButton.snp.height)
        }
    }

    @objc private func buyButtonTapped() {
        if tapCounter == 0 {
            increaseQuantity()
        }
    }
    
    private func updateButtonUI() {
        if tapCounter == 0 {
            buyButton.setTitle("В корзину", for: .normal)
            counterLabel.text = ""
            counterLabel.isHidden = true
            plusButton.isHidden =   true
            minusButton.isHidden =  true
            return
        }
        buyButton.setTitle("", for: .normal)
        counterLabel.text = "\(tapCounter)"
        counterLabel.isHidden = false
        plusButton.isHidden = false
        minusButton.isHidden = false
    }

    @objc func increaseQuantity() {
        tapCounter += 1
        updateButtonUI()
        addToCartAction?()
    }

    @objc func decreaseQuantity() {
        if tapCounter > 1 {
            tapCounter -= 1
            updateButtonUI()
            removeFromCartAction?()
        } else if tapCounter == 1 {
            tapCounter -= 1
            updateButtonUI()
            removeFromCartAction?()
        }
    }
}
