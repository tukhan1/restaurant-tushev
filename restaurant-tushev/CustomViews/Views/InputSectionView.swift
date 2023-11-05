//
//  InputSectionView.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 06.11.2023.
//

import UIKit

class InputSectionView: UIView {
    let titleLabel = UILabel()
    let textField = UITextField()
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.axis = .vertical
        stackView.spacing = 5
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
