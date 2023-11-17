//
//  LoyaltyView.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 09.11.2023.
//

import UIKit
import SnapKit

class LoyaltyView: UIView {
    private let loyaltyImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "loyalty")
        return imageView
    }()
    private let titleLabel: CustomLabel = CustomLabel(font: .title2, textAligment: .left, text: "Карта лояльности")
    private let amountLabel: CustomLabel = CustomLabel(font: .loyaltyFont, textColor: .darkBrown, textAligment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAmount(_ amount: Double) {
        amountLabel.text = "\(Int(amount)) баллов"
    }
    
    private func configure() {
        addSubviews(loyaltyImageView, titleLabel, amountLabel)
        layer.borderWidth = 0.5
        layer.cornerRadius = 15
    }

    private func makeConstraints() {
        loyaltyImageView.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-20)
            make.top.equalTo(self.snp.top)
            make.height.width.equalTo(self.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(20)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
            make.right.equalTo(loyaltyImageView.snp.left)
        }
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(loyaltyImageView.snp.left)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
