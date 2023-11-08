//
//  AddressView.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 07.11.2023.
//

import UIKit

class AddressView: UIView {
    
    var address: Address?
    
    private let nameLabel: UILabel = UILabel(frame: .zero)
    private let streetLabel: UILabel = UILabel(frame: .zero)
    private let houseLabel: UILabel = UILabel(frame: .zero)
    private let apartmentLabel: UILabel = UILabel(frame: .zero)
    
    private let emptyLabel: UILabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(with adress: Address) {
        self.address = adress
        emptyLabel.isHidden = true
        nameLabel.text = adress.name
        streetLabel.text = adress.street
        houseLabel.text = adress.houseNumber
        apartmentLabel.text = adress.apartment
    }
    
    private func configure() {
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        
        emptyLabel.text = "Добавить адрес"
        emptyLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        let labels = [nameLabel, streetLabel, houseLabel, apartmentLabel, emptyLabel]
        
        labels.forEach { label in
            addSubview(label)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15, weight: .thin)
        }
        
    }
    
    private func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
        }
        streetLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.left.equalTo(nameLabel.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
        }
        houseLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
        }
        apartmentLabel.snp.makeConstraints { make in
            make.top.equalTo(streetLabel.snp.bottom)
            make.right.equalTo(self.snp.right)
            make.left.equalTo(houseLabel.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
        }
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
}
