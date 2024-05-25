import UIKit

// Protocol for ProductDetailViewController interactions
public protocol ProductDetailViewControllerProtocol: AnyObject {
    func updateDetail(_ product: Product?)
}

public final class ProductDetailViewController: UIViewController,
                                                ProductDetailViewControllerProtocol {
    
    private let presenter: ProductDetailPresenterProtocol
    
    private weak var tableView: UITableView?
    
    private var tableDataSource: ProductDetailDataSource
    
    private var imageOfBucketInside: UIImage? {
        return presenter.stateOfBucket == .pressed ?
        UIImage(systemName: PublicConstants.SystemImages.cartFill) :
        UIImage(systemName: PublicConstants.SystemImages.cart)
    }
    
    private var imageOfFavorite: UIImage? {
        return presenter.stateOfFavorite == .pressed ?
        UIImage(systemName: PublicConstants.SystemImages.heartFill) :
        UIImage(systemName: PublicConstants.SystemImages.heart)
    }
    
    private lazy var toBucketButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: imageOfBucketInside,
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
        tableDataSource: ProductDetailDataSource
    ) {
        self.presenter = presenter
        self.tableDataSource = tableDataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarButtons()
        setupTable()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.setupStateButtons()
        presenter.showProduct()
        reloadButtons()
    }
    
    private func reloadButtons() {
        toFavoritesButton.image = imageOfFavorite
        toBucketButton.image = imageOfBucketInside
    }

    // MARK: - Setup
    
    private func setupNavigationBarButtons() {
       navigationItem.rightBarButtonItems = [toBucketButton, toFavoritesButton]
    }
    
    private func setupTable() {
        
        let table = UITableView()
        tableView = table
        table.dataSource = tableDataSource
        table.rowHeight = PublicConstants.Table.defaultCellHeight
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
    
    // MARK: - Actions
    
    @objc private func toFavoritesWasClicked() {
        toggleFavoriteState()
    }
    
    @objc private func toBucketWasClicked() {
        toggleBucketState()
    }
    
    // MARK: - Helper
    
    private func toggleFavoriteState() {
        presenter.toggleIsFavorite()
        toFavoritesButton.image = imageOfFavorite
    }
    
    private func toggleBucketState() {
        presenter.toggleIsBucketInside()
        toBucketButton.image = imageOfBucketInside
    }
    
    // MARK: - ProductDetailViewControllerProtocol
    
    public func updateDetail(_ product: Product?) {
        tableDataSource.currentProduct = product
        tableView?.reloadData()
    }
    
    // Required initializer for subclasses of UIViewController
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
