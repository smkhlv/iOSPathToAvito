import UIKit

public protocol ProductDetailViewControllerProtocol: AnyObject {
    func updateDetail(_ product: Product)
}

public final class ProductDetailViewController: UIViewController,
                                                ProductDetailViewControllerProtocol {
    
    private let presenter: ProductDetailPresenterProtocol
    
    private weak var tableView: UITableView?
    
    private var tableHandler: ProductDetailTableHandler
    
    private var imageOfFavorite: UIImage?
    private var imageOfBucket: UIImage?
    
    private var stateOfFavorite: StateButton = .unpressed
    private var stateOfBucket: StateButton = .unpressed
    
    private lazy var toBucketButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: imageOfBucket,
                                     style: .plain,
                                     target: self,
                                     action: #selector(toBucketWasClicked))
        return button
    }()
    
    private lazy var toFavoritesButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: imageOfFavorite,
                                     style: .plain,
                                     target: self,
                                     action: #selector(toFavoritesWasClicked))
        return button
    }()
    
    init(
        presenter: ProductDetailPresenterProtocol,
        tableHandler: ProductDetailTableHandler,
        imageOfFavorite: UIImage?,
        imageOfBucket: UIImage?
    ) {
        self.presenter = presenter
        self.tableHandler = tableHandler
        self.imageOfBucket = imageOfBucket
        self.imageOfFavorite = imageOfFavorite
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public func updateDetail(_ product: Product) {
        tableHandler.currentProduct = product
        tableView?.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarButtons()
        setupTable()
        presenter.showProduct()
    }
    
    private func setupNavigationBarButtons() {
       navigationItem.rightBarButtonItems = [toBucketButton, toFavoritesButton]
    }
    
    @objc private func toFavoritesWasClicked() {
        let image = stateOfFavorite == .unpressed ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        toFavoritesButton.image = image
        stateOfFavorite = stateOfFavorite == .unpressed ? .pressed : .unpressed
        
        presenter.changeIsFavorite()
    }
    
    @objc private func toBucketWasClicked() {
        let image = stateOfBucket == .unpressed ? UIImage(systemName: "cart.fill") : UIImage(systemName: "cart")
        toBucketButton.image = image
        stateOfBucket = stateOfBucket == .unpressed ? .pressed : .unpressed
        
        presenter.changeIsBucketInside()
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
