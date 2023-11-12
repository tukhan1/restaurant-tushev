import UIKit
import SnapKit

protocol CartVCDelegate: AnyObject {
    func cartVCWillDeinit(cartManager: CartManager)
}

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: CartVCDelegate?
    
    private let cartManager: CartManager
    private var currentAddress: Address?
    private var loyaltyPoints: Double?
    private var loyaltyPointsUsed: Double?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let deliverView = DeliverView(frame: .zero)
    private let addressView = AddressView(frame: .zero)
    private let loyaltyPointsSwitch = UISwitch()
    private let loyaltyPointsLabel = UILabel()

    init(cartManager: CartManager) {
        self.cartManager = cartManager
        super.init(nibName: nil, bundle: nil)
        updateTableViewHeight()
    }

    deinit {
        delegate?.cartVCWillDeinit(cartManager: cartManager)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        fetchAddress()
        fetchLoyalty()
    }
    
    private func fetchAddress() {
        UserService.shared.fetchAddress { [weak self] result in
            switch result {
            case .success(let address):
                DispatchQueue.main.async {
                    self?.addressView.setUp(with: address)
                    self?.currentAddress = address
                }
            case .failure(_):
                print("нет данных")
            }
        }
    }
    
    private func fetchLoyalty() {
        UserService.shared.fetchLoyaltyData { [weak self] result in
            switch result {
            case .success(let loyaltyCard):
                DispatchQueue.main.async { self?.loyaltyPoints = loyaltyCard.amount }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.loyaltyPointsLabel.isHidden = true
                    self?.loyaltyPointsSwitch.isHidden = true
                }
            }
        }
    }
    
    private func setupUI() {
        title = "Корзина"
        view.backgroundColor = .white
        // Инициализация и настройка таблицы
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductInCartCell.self)
        tableView.isUserInteractionEnabled = false
        // Настройка метки
        loyaltyPointsLabel.text = "Использовать баллы?"
        loyaltyPointsLabel.font = .systemFont(ofSize: 16)
        loyaltyPointsLabel.textColor = .black
        loyaltyPointsSwitch.addTarget(self, action: #selector(loyaltySwitchChanged), for: .valueChanged)

        view.addSubview(scrollView)
        scrollView.addSubviews(addressView, tableView, deliverView, loyaltyPointsSwitch, loyaltyPointsLabel)
        
        // Инициализация и настройка кнопки доставки
        deliverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliverTapped)))
        addressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressTapped)))
        
        // Обновление общей стоимости
        deliverView.setTotalPrice(cartManager.calculateTotalAmount())
    }
    
    @objc private func loyaltySwitchChanged(_ sender: UISwitch) {
        updateTotalAmount()
    }

    private func updateTotalAmount() {
        var totalAmount = cartManager.calculateTotalAmount()
        if loyaltyPointsSwitch.isOn {
            if let loyaltyPoints = loyaltyPoints {
                let discount = min(Double(loyaltyPoints), totalAmount - 1)
                totalAmount -= discount
                loyaltyPointsUsed = discount
                deliverView.setTotalPrice(totalAmount)
                return
            }
        }
        loyaltyPointsUsed = 0
        deliverView.setTotalPrice(totalAmount)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        addressView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        loyaltyPointsLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
        }
        loyaltyPointsSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(loyaltyPointsLabel.snp.centerY)
            make.right.equalTo(view.snp.right).offset(-10)
        }
        deliverView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.95)
            make.height.equalTo(50)
            make.top.equalTo(loyaltyPointsSwitch.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func updateTableViewHeight() {
        let height = cartManager.items.count * 100
        tableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        scrollView.contentSize = CGSize(width: view.frame.width, height: addressView.frame.height + deliverView.frame.height + loyaltyPointsSwitch.frame.height + CGFloat(height) + 20)
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func deliverTapped() {
        UserService.shared.saveOrder(Order(id: UUID().uuidString, date: Date(), totalAmount: cartManager.calculateTotalAmount())) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.cartManager.clearCart()
                    self?.navigationController?.popViewController(animated: true)
                    self?.presentAlert(withTitle: "Успешно", message: "Заказ успешно создан и оплачен. Ожидайте курьера.")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentErrorAlert(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func addressTapped() {
        let addressVC = AddressVC()
        if let address = currentAddress { addressVC.prefill(with: address) }
        addressVC.onSave = { [weak self] address in
            self?.addressView.setUp(with: address)
        }
        self.navigationController?.present(addressVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartManager.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductInCartCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: cartManager.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
}
