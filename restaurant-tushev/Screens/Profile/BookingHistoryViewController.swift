//
//  BookingHistoryViewController.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 12.11.2023.
//

class BookingHistoryViewController: HistoryViewController {
    override func fetchData() {
        UserService.shared.fetchBookingHistory { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let booking):
                self.data = booking.map { $0.id }
                self.tableView.reloadData()
            case .failure(let error):
                self.presentErrorAlert(withMessage: error.localizedDescription)
            }
        }
    }
}
