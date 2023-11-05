//
//  ChefRecommendationCell.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 04.11.2023.
//

import UIKit

class ChefRecommendationCell: UITableViewCell {
    
    private let masterClassImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           return iv
       }()
       
       private let titleLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 18)
           label.numberOfLines = 0
           return label
       }()
       
       private let descriptionLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14)
           label.numberOfLines = 0
           label.lineBreakMode = .byTruncatingTail
           return label
       }()
       
       private let dateLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 12)
           label.numberOfLines = 1
           label.textAlignment = .right
           return label
       }()
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupViews()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func setupViews() {
           addSubview(masterClassImageView)
           addSubview(titleLabel)
           addSubview(descriptionLabel)
           addSubview(dateLabel)
           
           backgroundColor = .white
           layer.cornerRadius = 10
           layer.masksToBounds = true
           layer.shadowOpacity = 0.1
           layer.shadowRadius = 5
           layer.shadowOffset = CGSize(width: 0, height: 5)
           layer.shadowColor = UIColor.black.cgColor
           
           masterClassImageView.snp.makeConstraints { make in
               make.leading.equalToSuperview().offset(10)
               make.top.equalToSuperview().offset(10)
               make.width.height.equalTo(self.snp.height).multipliedBy(0.9)
           }
           
           titleLabel.snp.makeConstraints { make in
               make.leading.equalTo(masterClassImageView.snp.trailing).offset(10)
               make.trailing.equalToSuperview().offset(-10)
               make.top.equalTo(masterClassImageView.snp.top)
           }
           
           descriptionLabel.snp.makeConstraints { make in
               make.leading.equalTo(titleLabel.snp.leading)
               make.trailing.equalTo(titleLabel.snp.trailing)
               make.top.equalTo(titleLabel.snp.bottom).offset(5)
           }
           
           dateLabel.snp.makeConstraints { make in
               make.leading.equalTo(titleLabel.snp.leading)
               make.trailing.equalTo(titleLabel.snp.trailing)
               make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
               make.bottom.equalTo(masterClassImageView.snp.bottom)
           }
       }
       
       func configure(with masterClass: MasterClass) {
           ImageStorageManager.shared.downloadImage(from: masterClass.imageUrl) {[weak self] image in
               guard let self = self else { return }
               DispatchQueue.main.async { self.masterClassImageView.image = image }
           }
           titleLabel.text = masterClass.title
           descriptionLabel.text = masterClass.description
           dateLabel.text = "Дата: \(masterClass.date)"
       }
}

