//
//  PromoDitailsVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 11.11.2023.
//

import UIKit
import SnapKit
import Kingfisher

class PromoDitailsVC: UIViewController {
    private let banner: Banner
    
    private let imageView: UIImageView = UIImageView(frame: .zero)
    private let titleLabel: CustomLabel = CustomLabel(font: .title2, textAligment: .left)
    private let descriptionLabel: CustomLabel = CustomLabel(font: .body, textAligment: .left)
    private let closeButton: UIButton = UIButton(frame: .zero)
    private let shereButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Поделиться", for: .normal)
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.tintColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    init(banner: Banner) {
        self.banner = banner
        super.init(nibName: nil, bundle: nil)
        configure()
        makeConstraints()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        if let url = URL(string: banner.imageUrl) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = banner.title
        descriptionLabel.text = banner.description
        shereButton.addTarget(nil, action: #selector(shereTapped), for: .touchUpInside)
    }
    
    @objc private func shereTapped() {
        let firstActivityItem = banner.title
        if let secondActivityItem = URL(string: banner.activeUrl ?? "") {
            let image : UIImage = imageView.image ?? .loyalty
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubviews(imageView,titleLabel,descriptionLabel,shereButton)
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        imageView.contentMode = .scaleAspectFill
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(30)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(30)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(100)
        }
        shereButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
    }
}
