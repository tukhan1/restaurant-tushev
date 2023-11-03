//
//  AuthenticationVC.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 25.10.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

class AuthenticationVC: UIViewController {
    
    private let enterPhoneLabel: CustomLabel = {
        return CustomLabel(font: .title1, text: "Введите свой номер")
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.textAlignment = .center
        return textField
    }()
    
    private var nextButton: CustomButton = {
        let button = CustomButton(title: "Далее")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubviews(enterPhoneLabel, phoneTextField, nextButton)
        nextButton.addTarget(nil, action: #selector(sendSmsVerification), for: .touchUpInside)
    }
    
    @objc private func sendSmsVerification() {
        // Добавить проверку формата
        print(phoneTextField.text ?? "")
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneTextField.text ?? "", uiDelegate: nil) {[weak self] verificationID, error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                let alert = self.createSmsAlertController()
                self.present(alert, animated: true)
            }
    }
    
    private func makeConstraints() {
        phoneTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
        }
        enterPhoneLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(phoneTextField.snp.top).offset(-5)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(40)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
    }
    
    func authGood() {
        print("YEAAAAAH BOY")
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
