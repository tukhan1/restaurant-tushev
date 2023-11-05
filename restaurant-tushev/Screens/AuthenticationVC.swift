//
//  AuthenticationVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 25.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthenticationVC: UIViewController {
    
    private let enterPhoneLabel = CustomLabel(font: .title1, text: "Введите свой номер")
    private let enterNameLabel = CustomLabel(font: .title1, text: "Введите ваше имя")
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Номер телефона"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.textAlignment = .center
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.textAlignment = .center
        return textField
    }()
    
    private let nextButton = CustomButton(title: "Далее")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(enterPhoneLabel, phoneTextField, enterNameLabel, nameTextField, nextButton)
        nextButton.addTarget(self, action: #selector(sendSmsVerification), for: .touchUpInside)
    }
    
    @objc private func sendSmsVerification() {
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
              let name = nameTextField.text, !name.isEmpty else {
            print("Необходимо ввести имя и номер телефона")
            return
        }
        
        // Проверяем, существует ли уже пользователь
        let db = Firestore.firestore()
        db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Ошибка при получении данных: \(err)")
            } else if querySnapshot!.documents.isEmpty {
                // Пользователь новый, отправляем СМС
                self?.verifyPhoneNumber(phoneNumber)
            } else {
                // Пользователь существует, пропускаем экран регистрации
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func verifyPhoneNumber(_ phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let alert = self.createSmsAlertController()
            self.present(alert, animated: true)
        }
    }
    
    func authGood() {
        guard let authResult = Auth.auth().currentUser else {
            print("Ошибка: пользователь не найден.")
            return
        }
        
        let userData: [String: Any] = [
            "uid": authResult.uid,
            "phoneNumber": authResult.phoneNumber ?? "",
            "name": nameTextField.text ?? ""
        ]
        
        let db = Firestore.firestore()
        db.collection("users").document(authResult.uid).setData(userData) { error in
            if let error = error {
                print("Ошибка при добавлении пользователя в Firestore: \(error)")
            } else {
                print("Пользователь успешно добавлен в Firestore.")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func makeConstraints() {
        enterPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(40)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(enterPhoneLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        enterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(enterNameLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }
}

extension AuthenticationVC {
    func createSmsAlertController() -> UIAlertController {
        let smsAlertController = UIAlertController(
            title: "Код подтверждения",
            message: "Введите проверочный код для завершения авторизации",
            preferredStyle: .alert
        )
        
        smsAlertController.addTextField() { smsCodeField in
            smsCodeField.placeholder = ""
            smsCodeField.keyboardType = .numberPad
            smsCodeField.textContentType = .oneTimeCode
        }
        
        let sendCodeToConfirm = UIAlertAction(title: "Отправить", style: .default) { [weak self] _ in
            guard let textFireldText = smsAlertController.textFields?.first?.text, let this = self else { return }
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: textFireldText)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error)
                    print(error)
                } else {
                    smsAlertController.dismiss(animated: true)
                    this.authGood()
                }
            }
        }
        
        sendCodeToConfirm.isEnabled = false
        
        smsAlertController.addAction(sendCodeToConfirm)
        smsAlertController.addAction(.init(title: "Отмена", style: .cancel, handler: { _ in
            smsAlertController.dismiss(animated: false)
        }))
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                               object: smsAlertController.textFields?.first,
                                               queue: .main) { (_) -> Void in
            guard let textFieldText = smsAlertController.textFields?.first?.text else { return }
            sendCodeToConfirm.isEnabled = textFieldText.count == 6 ? true : false
        }
        return smsAlertController
    }
}
