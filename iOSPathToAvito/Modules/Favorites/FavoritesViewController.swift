import UIKit

public protocol FavoritesViewControllerProtocol: AnyObject {
    
    func updateProductListTable(products: [UUID: Product])
}

public final class FavoritesViewController: UIViewController,
                                            FavoritesViewControllerProtocol {
    
    private let presenter: FavoritesPresenterProtocol
    
    private weak var tableView: UITableView?
    
    private var tableHandler: ProductListTableHandler
    
    init(presenter: FavoritesPresenterProtocol,
         tableHandler: ProductListTableHandler) {
        self.presenter = presenter
        self.tableHandler = tableHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.updateProductList()
    }
    
    public func updateProductListTable(products: [UUID: Product]) {
        tableHandler.products = products
        tableView?.reloadData()
    }
    
    private func setupTable() {
        
        let table = UITableView()
        tableView = table
        table.dataSource = tableHandler
        table.delegate = tableHandler
        table.register(ProductCell.self,
                       forCellReuseIdentifier: String(describing: ProductCell.self))
        
        view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
}
