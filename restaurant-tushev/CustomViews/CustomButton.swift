//
//  CustomButton.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 25.10.2023.
//

import UIKit

enum TypeOfButton {
    case nextButton
}

final class CustomButton: UIButton {

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configure()
//    }

    init(title: String, background color: UIColor? = .lightGray, textColor: UIColor = .black) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = color
        setTitleColor(textColor, for: .normal)
        layer.cornerRadius = 17
        layer.shadowOpacity = 0.05
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func updateUI(with buttonText: String ,buttonType: TypeOfButton) {
//        switch buttonType {
//        case .nextButton:
//            configureNextButton()
//            setTitle(buttonText, for: .normal)
//        }
//    }

//    private func configureNextButton() {
//        titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//    }

//    private func configure() {
//        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//    }
}
