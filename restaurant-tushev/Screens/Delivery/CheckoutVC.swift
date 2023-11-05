//
//  CheckoutVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 05.11.2023.
//

import UIKit
import SnapKit
import Firebase

class CheckoutVC: UIViewController {
    
    // MARK: - Properties
    private var loyaltyPointsAvailable: Int = 0
    private var loyaltyPointsToUse: Int = 0
    private var totalCost: Double = 0 // Общая стоимость заказа
    
    // MARK: - UI Elements
    
    private let stackView = UIStackView()
    private let addressSection = InputSectionView(title: "Адрес", placeholder: "Введите адрес доставки")
    private let apartmentSection = InputSectionView(title: "Квартира", placeholder: "Введите номер квартиры")
    private let buildingSection = InputSectionView(title: "Корпус", placeholder: "Введите корпус (если есть)")
    private let intercomSection = InputSectionView(title: "Домофон", placeholder: "Введите код домофона")
    private let commentSection = InputSectionView(title: "Комментарий", placeholder: "Добавьте комментарий к заказу")
    
    private let loyaltyPointsLabel = UILabel()
    private let loyaltyPointsSlider = UISlider()
    
    private let finalCostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    init(totalCost: Double, loyaltyPoints: Int) {
        self.totalCost = totalCost
        self.loyaltyPointsAvailable = loyaltyPoints
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTextFieldDelegates()
    }
    
    // MARK: - Setup
    
    private func setupTextFieldDelegates() {
        addressSection.textField.delegate = self
        apartmentSection.textField.delegate = self
        buildingSection.textField.delegate = self
        intercomSection.textField.delegate = self
        commentSection.textField.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Оформление заказа"
        
        // Настройка слайдера
        loyaltyPointsSlider.minimumValue = 0
        loyaltyPointsSlider.maximumValue = Float(loyaltyPointsAvailable)
        loyaltyPointsSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Настройка лейбла баллов лояльности
        updateLoyaltyPointsLabel()
        
        // Настройка кнопки оплаты
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        
        // Добавление элементов на view
        let apartmentAndBuildingStackView = UIStackView(arrangedSubviews: [apartmentSection, buildingSection])
        apartmentAndBuildingStackView.axis = .horizontal
        apartmentAndBuildingStackView.distribution = .fillEqually
        apartmentAndBuildingStackView.spacing = 10
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(addressSection)
        stackView.addArrangedSubview(apartmentAndBuildingStackView)
        stackView.addArrangedSubview(intercomSection)
        stackView.addArrangedSubview(commentSection)
        stackView.addArrangedSubview(loyaltyPointsLabel)
        stackView.addArrangedSubview(loyaltyPointsSlider)
        stackView.addArrangedSubview(finalCostLabel)
        stackView.addArrangedSubview(payButton)
        stackView.axis = .vertical
        stackView.spacing = 15
        
        view.addSubview(stackView)
        
        updateFinalCost()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
            let bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20).priority(.low)
            make.height.greaterThanOrEqualTo(0).priority(.high)
        }
    }
    
    // MARK: - Actions
    @objc private func sliderValueChanged(_ sender: UISlider) {
        loyaltyPointsToUse = Int(sender.value)
        updateLoyaltyPointsLabel()
        updateFinalCost()
    }
    
    @objc private func payButtonTapped() {
        // Проверка и сохранение данных
        // ...
        
        print("Заказ оформлен")
    }
    
    // MARK: - Helpers
    private func updateLoyaltyPointsLabel() {
        let pointsToUse = Int(loyaltyPointsSlider.value)
        loyaltyPointsLabel.text = "Использовать баллы: \(pointsToUse) из \(loyaltyPointsAvailable)"
    }
    
    private func updateFinalCost() {
        let finalCost = totalCost - Double(loyaltyPointsToUse) // Предполагается, что 1 балл = 1 рубль
        finalCostLabel.text = "К оплате: \(finalCost) руб."
    }
    
    private func validateFields() {
        let fields = [addressSection.textField, apartmentSection.textField, buildingSection.textField, intercomSection.textField, commentSection.textField]
        let allFieldsFilled = fields.allSatisfy { $0.text?.isEmpty == false }
        payButton.isEnabled = allFieldsFilled
        payButton.alpha = allFieldsFilled ? 1.0 : 0.5
    }
}

// MARK: - UITextFieldDelegate
extension CheckoutVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
