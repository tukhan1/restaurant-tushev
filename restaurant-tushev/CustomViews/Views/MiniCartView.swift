//
//  MiniCartView.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit

class MiniCartView: UIView {
    
    private let totalPriceLabel: CustomLabel = {
        let label = CustomLabel(font: .body, textAligment: .right)
        label.text = "0 Р"
        return label
    }()
    
    private let mainLabel: CustomLabel = {
        let label = CustomLabel(font: .body)
        label.text = "Заказать"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCart() {
        self.isHidden = false
        // Add animation if desired
    }
    
    func hideCart() {
        self.isHidden = true
        // Add animation if desired
    }
    
    private func setupViews() {
        layer.cornerRadius = 20
        backgroundColor = .yellow
        addSubviews(mainLabel, totalPriceLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(mainLabel.snp.right)
            make.right.equalTo(self.snp.right).inset(10)
            make.height.equalTo(50)
        }
    }
    
    func updateTotalPrice() {
        let total = calculateTotalCost()
        totalPriceLabel.text = formatAsCurrency(total)
    }
    
    private func calculateTotalCost() -> Double {
        return CartManager.shared.items.reduce(0.0) { total, product in
            total + parsePrice(product.cost)
        }
    }
    
    private func parsePrice(_ price: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let number = formatter.number(from: price) {
            return number.doubleValue
        }
        return 0.0
    }
    
    private func formatAsCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.currencySymbol = "Р"
        
        return formatter.string(from: NSNumber(value: value)) ?? "0 Р"
    }
}
