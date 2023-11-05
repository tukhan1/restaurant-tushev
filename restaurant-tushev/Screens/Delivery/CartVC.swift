import UIKit
import SnapKit

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let deliverView = DeliverView(frame: .zero)
    
    private var cartItems: [Product] = []
    
    init(products: [Product]) {
        super.init(nibName: nil, bundle: nil)
        self.cartItems = products
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductInCartCell.self)
        view.addSubview(tableView)
        
        // Инициализация и настройка кнопки доставки
        view.addSubview(deliverView)
        deliverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliverTapped)))
        
        // Обновление общей стоимости
        updateTotalCost()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(deliverView.snp.bottom)
        }
        
        deliverView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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
}
