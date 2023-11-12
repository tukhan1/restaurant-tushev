//
//  DeliverView.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 04.11.2023.
//

import UIKit
import SnapKit

class DeliverView: UIView {
  
    private let titleLabel = CustomLabel(font: .title4, textAligment: .center, text: "Оплатить и доставить")
    private let totalPriceLabel = CustomLabel(font: .title4, textAligment: .right, text: "0 Р")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowOpacity = 0.15
        addSubviews(titleLabel, totalPriceLabel)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
        }
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalToSuperview()
        }
    }
    
    func setTotalPrice(_ total: Double) {
        totalPriceLabel.text = "\(total) Р"
    }
}
