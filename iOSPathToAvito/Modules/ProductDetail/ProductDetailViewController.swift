import UIKit

public protocol ProductDetailViewControllerProtocol: AnyObject { }

public final class ProductDetailViewController: UIViewController,
                                                ProductDetailViewControllerProtocol {
    
    private let presenter: ProductDetailPresenterProtocol
    
    private weak var tableView: UITableView?
    
    private var tableHandler: ProductDetailTableHandler
    
    init(presenter: ProductDetailPresenterProtocol,
         tableHandler: ProductDetailTableHandler) {
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
    
    private func setupTable() {
        
        let table = UITableView()
        tableView = table
        table.dataSource = tableHandler
        table.register(ProductCellDetail.self,
                       forCellReuseIdentifier: String(describing: ProductCellDetail.self))
        
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
