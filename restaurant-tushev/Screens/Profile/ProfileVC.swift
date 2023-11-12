import UIKit
import SnapKit

class ProfileVC: UIViewController {
    
    // MARK: - UI Components
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        // Здесь должен быть номер телефона пользователя, полученный из модели данных
        label.text = "Номер телефона: +1234567890"
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isScrollEnabled = false
        return table
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupLayout()
        setupTableView()
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubviews(phoneNumberLabel, tableView, signOutButton)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view)
            make.bottom.equalTo(signOutButton.snp.top).offset(-20)
        }

        signOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    @objc private func signOutTapped() {
        UserService.shared.signOut { [weak self] success, error in
            if success {
                DispatchQueue.main.async {
                    self?.showLoginScreen()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self?.presentErrorAlert(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    private func showLoginScreen() {
        let authVC = AuthVC()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.window?.rootViewController = authVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    private func fetchUser() {
        UserService.shared.fetchUser { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.phoneNumberLabel.text =  "Номер телефона: " + (user.phoneNumber)
                }
            case .failure(let error):
                self?.presentErrorAlert(withMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "История заказов"
            cell.imageView?.image = UIImage(systemName: "bag")
        case 1:
            cell.textLabel?.text = "История бронирования"
            cell.imageView?.image = UIImage(systemName: "calendar")
        case 2:
            cell.textLabel?.text = "Мои адреса"
            cell.imageView?.image = UIImage(systemName: "map")
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // Высота ячейки
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
