import UIKit
import SnapKit

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let deliverView = DeliverView(frame: .zero)
    private let addressView = AddressView(frame: .zero)
    
    private var cartItems: [Product] = []
    
    init(products: [Product]) {
        super.init(nibName: nil, bundle: nil)
        self.cartItems = products
        updateTableViewHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
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

        view.addSubview(scrollView)
        scrollView.addSubviews(addressView, tableView, deliverView)
        
        // Инициализация и настройка кнопки доставки
        deliverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliverTapped)))
        addressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressTapped)))
        
        // Обновление общей стоимости
        updateTotalCost()
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
        
        deliverView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
            make.top.equalTo(tableView.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func updateTableViewHeight() {
        let height = cartItems.count * 100
        tableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        // Обновите contentSize scrollView, если он зависит от высоты tableView
        scrollView.contentSize = CGSize(width: view.frame.width, height: addressView.frame.height + deliverView.frame.height + CGFloat(height) + 20)
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateTotalCost() {
        // Здесь должна быть логика для расчета общей стоимости
        let totalCost = cartItems.reduce(0) { $0 + ($1.cost.parsePrice() ?? 0.0) }
        deliverView.setTotalPrice("\(totalCost)")
    }
    
    @objc private func deliverTapped() {
        print("Заказ на доставку оформлен")
    }
    
    @objc private func addressTapped() {
        let addressVC = AddressVC()
        addressVC.onSave = { [weak self] address in
            // Обновите ваш AddressView здесь
            self?.addressView.setUp(with: address)
        }
        self.navigationController?.present(addressVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductInCartCell = tableView.dequeueReusableCell(for: indexPath)
        let product = cartItems[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
