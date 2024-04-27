import UIKit

struct ModuleFactory {
    
    static func buildBucketList(coordinator: BucketListCoordinatorProtocol,
                                loader: LoaderProtocol,
                                dataStore: DataStoreProtocol) -> UIViewController {
        
        let interactor = BucketListInteractor(loader: loader,
                                              dataStore: dataStore)
        let presenter = BucketListPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = BucketListViewController(presenter: presenter,
                                            tableHandler: tableHandler)
        
        presenter.view = view
        interactor.output = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    static func buildProductList(coordinator: ProductListCoordinatorProtocol,
                                 loader: LoaderProtocol,
                                 dataStore: DataStoreProtocol) -> UIViewController {
        let interactor = ProductListInteractor(loader: loader,
                                               dataStore: dataStore)
        let tableHandler = ProductListTableHandler()
        let presenter = ProductListPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let view = ProductListViewController(presenter: presenter,
                                             tableHandler: tableHandler)
        
        presenter.view = view
        interactor.output = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    static func buildFavorites(coordinator: FavoritesCoordinatorProtocol,
                               loader: LoaderProtocol,
                               dataStore: DataStoreProtocol) -> UIViewController {
        let interactor = FavoritesInteractor(loader: loader,
                                             dataStore: dataStore)
        let presenter = FavoritesPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = FavoritesViewController(presenter: presenter,
                                           tableHandler: tableHandler)
        
        presenter.view = view
        interactor.output = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    static func buildProductDetail(product: Product) -> UIViewController {
        let presenter = ProductDetailPresenter()
        let tableHandler = ProductDetailTableHandler(currentProduct: product)
        let view = ProductDetailViewController(presenter: presenter,
                                           tableHandler: tableHandler)
        
        presenter.view = view
        return view
    }
}
