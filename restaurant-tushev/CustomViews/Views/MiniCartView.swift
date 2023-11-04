//
//  MiniCartView.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit
import SnapKit

enum MiniCartSize {
    static let weightAndHeight: Int = 50
}

class MiniCartView: UIView {
    
    private let cartImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = CGFloat(MiniCartSize.weightAndHeight / 2)
        backgroundColor = .black
        
        addSubview(cartImageView)
        
        cartImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
    }
}
