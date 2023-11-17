//
//  AddressVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 07.11.2023.
//


import UIKit
import Firebase

class AddressVC: UIViewController {
    
    var onSave: ((Address) -> Void)?
    
    // MARK: - UI Components
    private let nameTextField = UITextField()
    private let streetTextField = UITextField()
    private let houseNumberTextField = UITextField()
    private let apartmentTextField = UITextField()
    private let buildingTextField = UITextField()
    private let intercomTextField = UITextField()
    private let addButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAddButton()
        prefill()
    }
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        
        // Configure text fields
        let textFields = [nameTextField, streetTextField, houseNumberTextField, apartmentTextField, buildingTextField, intercomTextField]
        let placeholders = ["Имя клиента", "Улица", "Дом", "Квартира", "Корпус", "Домофон"]
        
        for (textField, placeholder) in zip(textFields, placeholders) {
            textField.borderStyle = .roundedRect
            textField.placeholder = placeholder
            view.addSubview(textField)
        }
        
        // Configure button
        addButton.setTitle("Добавить адрес", for: .normal)
        addButton.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        addButton.isEnabled = false // Initially disabled
        view.addSubview(addButton)
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        streetTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.left.right.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        houseNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(streetTextField.snp.bottom).offset(10)
            make.left.right.equalTo(streetTextField)
            make.height.equalTo(streetTextField)
        }
        
        apartmentTextField.snp.makeConstraints { make in
            make.top.equalTo(houseNumberTextField.snp.bottom).offset(10)
            make.left.right.equalTo(houseNumberTextField)
            make.height.equalTo(houseNumberTextField)
        }
        
        buildingTextField.snp.makeConstraints { make in
            make.top.equalTo(apartmentTextField.snp.bottom).offset(10)
            make.left.right.equalTo(apartmentTextField)
            make.height.equalTo(apartmentTextField)
        }
        
        intercomTextField.snp.makeConstraints { make in
            make.top.equalTo(buildingTextField.snp.bottom).offset(10)
            make.left.right.equalTo(buildingTextField)
            make.height.equalTo(buildingTextField)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(intercomTextField.snp.bottom).offset(20)
            make.left.right.equalTo(intercomTextField)
            make.height.equalTo(50)
        }
    }
    
    private func setupAddButton() {
        [nameTextField, streetTextField, houseNumberTextField, apartmentTextField].forEach { textField in
            textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        }
    }
    
    // MARK: - Actions
    @objc private func addAddressButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let street = streetTextField.text, !street.isEmpty,
              let houseNumber = houseNumberTextField.text, !houseNumber.isEmpty,
              let apartment = apartmentTextField.text, !apartment.isEmpty else {
            return
        }
        
        let address = Address(
            name: name,
            street: street,
            houseNumber: houseNumber,
            apartment: apartment,
            building: buildingTextField.text,
            intercom: intercomTextField.text
        )
        
        UserService.shared.saveAddress(address) { [weak self] result in
            switch result {
            case .success():
                print("Адрес успешно добавлен")
                DispatchQueue.main.async {
                    self?.onSave?(address)
                    self?.dismiss(animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentErrorAlert(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    private func prefill() {
        UserService.shared.fetchAddress { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let address):
                DispatchQueue.main.async {
                    self.nameTextField.text = address.name
                    self.streetTextField.text = address.street
                    self.houseNumberTextField.text = address.houseNumber
                    self.apartmentTextField.text = address.apartment
                    self.buildingTextField.text = address.building
                    self.intercomTextField.text = address.intercom
                }
            case .failure(_):
                print("нет данных")
            }
        }
    }
    
    @objc private func textFieldChanged() {
        addButton.isEnabled = !nameTextField.text!.isEmpty && !streetTextField.text!.isEmpty && !houseNumberTextField.text!.isEmpty && !apartmentTextField.text!.isEmpty
    }
}
