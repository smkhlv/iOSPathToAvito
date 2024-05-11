import UIKit

// Protocol defining the interface for the BucketListViewController
public protocol BucketListViewControllerProtocol: AnyObject {

    func append(products: [Product])
    
    func reload(products: [Product])
    
    func delete(products: [Product])
}

public final class BucketListViewController: UIViewController,
                                             BucketListViewControllerProtocol {
    
    private let presenter: BucketListPresenterProtocol
    
    private weak var tableView: UITableView?
    
    private var tableDataSource: ProductListDataSource
    
    init(presenter: BucketListPresenterProtocol,
         tableDataSource: ProductListDataSource) {
        self.presenter = presenter
        self.tableDataSource = tableDataSource
        
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
        presenter.fetchProducts()
    }
    
    public func append(products: [Product]) {
        tableDataSource.appendItems(products: products)
    }
    
    public func reload(products: [Product]) {
        tableDataSource.reloadItems(products: products)
    }
    
    public func delete(products: [Product]) {
        tableDataSource.deleteItems(products: products)
    }
    
    private func setupTable() {
        
        let table = UITableView()
        tableView = table
        tableDataSource.setupDataSource(table: table)
        table.delegate = tableDataSource
        table.rowHeight = PublicConstants.Table.defaultCellHeight
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
