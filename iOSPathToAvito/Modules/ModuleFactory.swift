import UIKit

// Factory for building modules
struct ModuleFactory {
    
    // Builds the Bucket List module
    static func buildBucketList(
        coordinator: BucketListCoordinatorProtocol,
        dataService: ProductDataServiceProtocol
    ) -> UIViewController {
        
        let interactor = BucketListInteractor(productDataService: dataService)
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
        dataService: ProductDataServiceProtocol
    ) -> UIViewController {
        
        let interactor = ProductListInteractor(productDataService: dataService)
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
        dataService: ProductDataServiceProtocol
    ) -> UIViewController {
        
        let interactor = FavoritesInteractor(productDataService: dataService)
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
        dataService: ProductDataServiceProtocol
    ) -> UIViewController {
        
        let interactor = ProductDetailInteractor(productDataService: dataService,
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
