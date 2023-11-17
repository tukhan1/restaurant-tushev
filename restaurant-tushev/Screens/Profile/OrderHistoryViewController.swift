//
//  OrderHistoryViewController.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 12.11.2023.
//

class OrderHistoryViewController: HistoryViewController {
    override func fetchData() {
        UserService.shared.fetchOrderHistory { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.data = orders.map { $0.id }
                self.tableView.reloadData()
            case .failure(let error):
                self.presentErrorAlert(withMessage: error.localizedDescription)
            }
        }
    }
}
