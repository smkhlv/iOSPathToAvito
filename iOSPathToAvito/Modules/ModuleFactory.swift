import UIKit

// Factory for building modules
struct ModuleFactory {
    
    // Builds the Bucket List module
    static func buildBucketList(
        coordinator: BucketListCoordinatorProtocol,
        loader: LoaderProtocol,
        dataManager: DataServiceProtocol,
        subject: SubjectInteractorProtocol
    ) -> UIViewController {
        
        let interactor = BucketListInteractor(loader: loader, dataManager: dataManager)
        let presenter = BucketListPresenter(coordinator: coordinator, interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = BucketListViewController(presenter: presenter,
                                            tableHandler: tableHandler)
        subject.add(interactor)
        interactor.subject = subject
        presenter.subject = subject
        presenter.view = view
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    // Builds the Product List module
    static func buildProductList(
        coordinator: ProductListCoordinatorProtocol,
        loader: LoaderProtocol,
        dataManager: DataServiceProtocol,
        subject: SubjectInteractorProtocol
    ) -> UIViewController {
        
        let interactor = ProductListInteractor(loader: loader, dataManager: dataManager)
        let presenter = ProductListPresenter(coordinator: coordinator, interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = ProductListViewController(presenter: presenter, tableHandler: tableHandler)
        
        subject.add(interactor)
        interactor.subject = subject
        presenter.subject = subject
        presenter.view = view
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    // Builds the Favorites module
    static func buildFavorites(
        coordinator: FavoritesCoordinatorProtocol,
        loader: LoaderProtocol,
        dataManager: DataServiceProtocol,
        subject: SubjectInteractorProtocol
    ) -> UIViewController {
        
        let interactor = FavoritesInteractor(loader: loader, dataManager: dataManager)
        let presenter = FavoritesPresenter(coordinator: coordinator, interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = FavoritesViewController(presenter: presenter, tableHandler: tableHandler)
        
        subject.add(interactor)
        interactor.subject = subject
        presenter.subject = subject
        presenter.view = view
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    // Builds the Product Detail module
    static func buildProductDetail(
        product: Product,
        subject: SubjectInteractorProtocol?
    ) -> UIViewController {
        
        let interactor = ProductDetailInteractor(currentProduct: product)
        let presenter = ProductDetailPresenter(interactor: interactor)
        let tableHandler = ProductDetailTableHandler()
        
        let stateOfFavorite: StateButton = product.isFavorite ? .pressed : .unpressed
        let stateOfBucket: StateButton = product.isBucketInside ? .pressed : .unpressed
        
        let view = ProductDetailViewController(presenter: presenter,
                                               tableHandler: tableHandler,
                                               stateOfFavorite: stateOfFavorite,
                                               stateOfBucket: stateOfBucket
        )
        
        subject?.add(interactor)
        interactor.subject = subject
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        presenter.view = view
        return view
    }
}
