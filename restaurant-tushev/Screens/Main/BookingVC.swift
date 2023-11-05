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
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        return picker
    }()
    
    private let numberOfGuestsPicker: UIPickerView = UIPickerView()
    
    private let reserveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забронировать", for: .normal)
        button.backgroundColor = .systemBlue
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
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubviews(datePicker, numberOfGuestsPicker, reserveButton)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
        
        numberOfGuestsPicker.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
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
        // Здесь будет логика бронирования столика
        // Например, отправка данных на сервер или сохранение в базу данных
        print("Столик забронирован на \(datePicker.date) для \(numberOfGuestsOptions[numberOfGuestsPicker.selectedRow(inComponent: 0)]) гостей.")
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
