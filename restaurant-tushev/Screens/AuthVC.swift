//
//  AuthVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 25.10.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class AuthVC: UIViewController {
    
    // MARK: - UI Components
    private let titleLabel: CustomLabel = CustomLabel(font: .title1)
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 15
        textField.placeholder = "Введите номер телефона"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let sendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отправить код", for: .normal)
        button.addTarget(nil, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        checkAuthentication()
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        titleLabel.text = "Вход"
        
        view.addSubviews(titleLabel, phoneNumberTextField, sendCodeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumberTextField.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    
    // MARK: - Authentication Check
    private func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            navigateToMainInterface()
        }
    }
    
    private func navigateToMainInterface() {
        let mainController = CustomTabBar()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.window?.rootViewController = mainController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - Actions
    @objc private func sendCodeButtonTapped() {
        sendVerificationCode()
    }
    
    private func sendVerificationCode() {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            self.presentErrorAlert(withMessage: "Номер телефона не должен быть пустым")
            return
        }
        
        UserService.shared.verifyPhoneNumber(phoneNumber) { [weak self] result in
            switch result {
            case .success(let verificationID):
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                DispatchQueue.main.async {
                    self?.showCodeInputAlert()
                }
            case .failure(let error):
                self?.presentErrorAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func showCodeInputAlert() {
        let alertController = UIAlertController(title: "Введите код", message: "Код был отправлен в SMS", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "SMS код"
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { [weak self] _ in
            if let code = alertController.textFields?.first?.text {
                self?.verifyCodeAndSignIn(code: code)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func verifyCodeAndSignIn(code: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            self.presentErrorAlert()
            return
        }
        
        UserService.shared.signInWithVerificationCode(code, verificationID: verificationID) { [weak self] result in
            switch result {
            case .success():
                self?.createLoyaltyCard()
                self?.navigateToMainInterface()
            case .failure(let error):
                self?.presentErrorAlert(withMessage: "Код введен не верно. Пожалуйста, попробуйте еще раз.")
                print(error.localizedDescription)
            }
        }
    }
    
    private func createLoyaltyCard() {
        let loyaltyCard = Loyalty(id: UUID().uuidString, amount: 0)
        UserService.shared.createLoyaltyCard(loyaltyCard) { result in
            switch result {
            case .success():
                print("Карта лояльности успешно создана")
            case .failure(let error):
                print("Ошибка при создании карты лояльности: \(error.localizedDescription)")
            }
        }
    }
}
