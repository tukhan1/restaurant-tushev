//
//  CartVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit

final class CartVC: UIViewController {

    private var products: [Product] = []
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(font: .title2, textAligment: .left)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeConstraints()
    }
    
    init(products: [Product]) {
        super.init(nibName: nil, bundle: nil)
        self.products = products
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func makeConstraints() {
        
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
