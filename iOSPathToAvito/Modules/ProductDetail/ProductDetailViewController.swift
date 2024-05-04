import UIKit

// Protocol for ProductDetailViewController interactions
public protocol ProductDetailViewControllerProtocol: AnyObject {
    func updateDetail(_ product: Product)
}

public final class ProductDetailViewController: UIViewController,
                                                ProductDetailViewControllerProtocol {
    
    private let presenter: ProductDetailPresenterProtocol
    
    private weak var tableView: UITableView?
    
    private var tableHandler: ProductDetailTableHandler

    private var stateOfFavorite: StateButton = .unpressed
    private var stateOfBucket: StateButton = .unpressed
    
    private var imageOfBucketInside: UIImage? {
       return stateOfBucket == .pressed ?
        UIImage(systemName: PublicConstants.SystemImages.cartFill) :
        UIImage(systemName: PublicConstants.SystemImages.cart)
    }
    
    private var imageOfFavorite: UIImage? {
        return stateOfFavorite == .pressed ?
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
        tableHandler: ProductDetailTableHandler,
        stateOfFavorite: StateButton,
        stateOfBucket: StateButton
    ) {
        self.presenter = presenter
        self.tableHandler = tableHandler
        self.stateOfFavorite = stateOfFavorite
        self.stateOfBucket = stateOfBucket
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarButtons()
        setupTable()
        presenter.showProduct()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.removeSubjectFromObservers()
    }

    // MARK: - Setup
    
    private func setupNavigationBarButtons() {
       navigationItem.rightBarButtonItems = [toBucketButton, toFavoritesButton]
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
    
    // MARK: - Actions
    
    @objc private func toFavoritesWasClicked() {
        toggleFavoriteState()
        presenter.changeIsFavorite()
    }
    
    @objc private func toBucketWasClicked() {
        toggleBucketState()
        presenter.changeIsBucketInside()
    }
    
    // MARK: - Helper
    
    private func toggleFavoriteState() {
        stateOfFavorite = stateOfFavorite == .pressed ? .unpressed : .pressed
        toFavoritesButton.image = imageOfFavorite
        presenter.changeIsFavorite()
    }
    
    private func toggleBucketState() {
        stateOfBucket = stateOfBucket == .pressed ? .unpressed : .pressed
        toBucketButton.image = imageOfBucketInside
        presenter.changeIsBucketInside()
    }
    
    // MARK: - ProductDetailViewControllerProtocol
    
    public func updateDetail(_ product: Product) {
        tableHandler.currentProduct = product
        tableView?.reloadData()
    }
    
    // Required initializer for subclasses of UIViewController
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
