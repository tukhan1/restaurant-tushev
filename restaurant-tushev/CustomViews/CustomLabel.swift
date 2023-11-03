//
//  CustomLabel.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 25.10.2023.
//

import UIKit

enum LabelFonts {
    case title1, title2, title3, title4, body, promt
}

class CustomLabel: UILabel {
    
    init(font: LabelFonts, textColor: UIColor = .black, textAligment: NSTextAlignment = .center, text: String = "") {
        super.init(frame: .zero)
        
        updateLabel(with: font)
        
        self.lineBreakMode = .byTruncatingTail
        self.textAlignment = textAligment
        self.textColor = textColor
        self.text = text
    }
    
    private func updateLabel(with font: LabelFonts) {
        switch font {
        case .title1:
            self.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        case .title2:
            self.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .title3:
            self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        case .title4:
            self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        case .body:
            self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        case .promt:
            self.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
