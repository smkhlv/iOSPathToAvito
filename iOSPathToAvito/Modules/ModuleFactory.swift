import UIKit

// Factory for building modules
struct ModuleFactory {
    
    // Builds the Bucket List module
    static func buildBucketList(
        coordinator: BucketListCoordinatorProtocol,
        repository: RepositoryProtocol
    ) -> UIViewController {
        
        let interactor = BucketListInteractor(repository: repository)
        let presenter = BucketListPresenter(coordinator: coordinator, interactor: interactor)
        let tableDataSource = ProductListDataSource()
        let view = BucketListViewController(presenter: presenter,
                                            tableDataSource: tableDataSource)

        presenter.view = view
        interactor.output = presenter
        tableDataSource.delegate = presenter
        return view
    }
    
    // Builds the Product List module
    static func buildProductList(
        coordinator: ProductListCoordinatorProtocol,
        repository: RepositoryProtocol
    ) -> UIViewController {
        
        let interactor = ProductListInteractor(repository: repository)
        let presenter = ProductListPresenter(coordinator: coordinator, interactor: interactor)
        let tableDataSource = ProductListDataSource()
        let view = ProductListViewController(presenter: presenter, tableDataSource: tableDataSource)

        presenter.view = view
        interactor.output = presenter
        tableDataSource.delegate = presenter
        return view
    }
    
    // Builds the Favorites module
    static func buildFavorites(
        coordinator: FavoritesCoordinatorProtocol,
        repository: RepositoryProtocol
    ) -> UIViewController {
        
        let interactor = FavoritesInteractor(repository: repository)
        let presenter = FavoritesPresenter(coordinator: coordinator, interactor: interactor)
        let tableDataSource = ProductListDataSource()
        let view = FavoritesViewController(presenter: presenter, tableDataSource: tableDataSource)
        
        presenter.view = view
        interactor.output = presenter
        tableDataSource.delegate = presenter
        return view
    }
    
    // Builds the Product Detail module
    static func buildProductDetail(
        product: Product,
        repository: RepositoryProtocol
    ) -> UIViewController {
        
        let interactor = ProductDetailInteractor(repository: repository,
                                                 product: product)
        let presenter = ProductDetailPresenter(interactor: interactor)
        let tableDataSource = ProductDetailDataSource()
        
        let view = ProductDetailViewController(presenter: presenter,
                                               tableDataSource: tableDataSource
        )
        
        interactor.output = presenter
        presenter.view = view
        return view
    }
}
