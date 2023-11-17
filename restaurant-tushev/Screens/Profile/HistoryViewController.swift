//
//  HistoryViewController.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 12.11.2023.
//

import UIKit
import SnapKit

class HistoryViewController: UIViewController {
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var data: [String] = [] // Данные для отображения

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
        fetchData()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Fetch Data
    func fetchData() {
        // Переопределяется в подклассах
    }
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.isEmpty ? 1 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if data.isEmpty {
            cell.textLabel?.text = "Данных нет"
        } else {
            cell.textLabel?.text = data[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    // Реализация методов делегата и источника данных
}

