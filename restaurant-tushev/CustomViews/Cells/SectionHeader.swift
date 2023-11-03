//
//  SectionHeader.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 02.11.2023.
//

import UIKit
import SnapKit

final class SectionHeader: UICollectionReusableView {
    
    let titleLabel: CustomLabel = {
        let label = CustomLabel(font: .title2)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        backgroundColor = .white
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).inset(10)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(40)
        }
    }
}
