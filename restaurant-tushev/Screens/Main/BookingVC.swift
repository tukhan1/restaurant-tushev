//
//  BookingVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 05.11.2023.
//

import UIKit

class BookingVC: UIViewController {
    
    // UI Elements
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 60
        picker.minimumDate = Date()
        var oneYearAhead = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        oneYearAhead = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: oneYearAhead)!
        picker.maximumDate = oneYearAhead
        return picker
    }()
    
    private let numberOfGuestsPicker: UIPickerView = UIPickerView()
    
    private let reserveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забронировать", for: .normal)
        button.backgroundColor = .lightBrown
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // Data
    private let numberOfGuestsOptions = Array(1...10) // Допустим, от 1 до 10 гостей
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupPicker()
        reserveButton.addTarget(self, action: #selector(reserveButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubviews(datePicker, numberOfGuestsPicker, reserveButton)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(370)
        }
        numberOfGuestsPicker.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(100)
        }
        reserveButton.snp.makeConstraints { make in
            make.top.equalTo(numberOfGuestsPicker.snp.bottom).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupPicker() {
        numberOfGuestsPicker.delegate = self
        numberOfGuestsPicker.dataSource = self
    }
    
    // MARK: - Actions
    @objc private func reserveButtonTapped() {
        let reservation = Reservation(id: UUID().uuidString, date: datePicker.date, numberOfGuests: numberOfGuestsOptions[numberOfGuestsPicker.selectedRow(inComponent: 0)])
        UserService.shared.saveReservation(reservation) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                    self?.presentAlert(withTitle: "Замечательно", message:  "Столик забронирован на \(reservation.date.formatted(date: .abbreviated, time: .shortened)) для \(reservation.numberOfGuests) гостей. В ближайшее время с вами свяжется наш менеджер, для подтверждения бронирования")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentErrorAlert(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: sender.date)
            if hour < 8 {
                sender.date = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: sender.date)!
            } else if hour > 20 {
                sender.date = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: sender.date)!
            }
        }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension BookingVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfGuestsOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberOfGuestsOptions[row]) гость(ей)"
    }
}
