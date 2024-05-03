import UIKit

struct ModuleFactory {
    
    static func buildBucketList(coordinator: BucketListCoordinatorProtocol,
                                loader: LoaderProtocol,
                                dataManager: DS,
                                subject: SubjectInteractorProtocol) -> UIViewController {
        
        let interactor = BucketListInteractor(loader: loader,
                                              dataManager: dataManager)
        let presenter = BucketListPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = BucketListViewController(presenter: presenter,
                                            tableHandler: tableHandler)
        subject.add(interactor)
        interactor.subject = subject
        presenter.view = view
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    static func buildProductList(coordinator: ProductListCoordinatorProtocol,
                                 loader: LoaderProtocol,
                                 dataManager: DS,
                                 subject: SubjectInteractorProtocol) -> UIViewController {
        let interactor = ProductListInteractor(loader: loader,
                                               dataManager: dataManager)
        let tableHandler = ProductListTableHandler()
        let presenter = ProductListPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let view = ProductListViewController(presenter: presenter,
                                             tableHandler: tableHandler)
        
        subject.add(interactor)
        interactor.subject = subject
        presenter.view = view
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    static func buildFavorites(coordinator: FavoritesCoordinatorProtocol,
                               loader: LoaderProtocol,
                               dataManager: DS,
                               subject: SubjectInteractorProtocol) -> UIViewController {
        let interactor = FavoritesInteractor(loader: loader,
                                             dataManager: dataManager)
        let presenter = FavoritesPresenter(coordinator: coordinator,
                                            interactor: interactor)
        let tableHandler = ProductListTableHandler()
        let view = FavoritesViewController(presenter: presenter,
                                           tableHandler: tableHandler)
        
        subject.add(interactor)
        interactor.subject = subject
        presenter.view = view
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        tableHandler.delegate = presenter
        return view
    }
    
    static func buildProductDetail(product: Product,
                                   subject: SubjectInteractorProtocol?) -> UIViewController {
        let interactor = ProductDetailInteractor(currentProduct: product)
        let presenter = ProductDetailPresenter(interactor: interactor)
        let tableHandler = ProductDetailTableHandler()
        let imageOfFavorite = product.isFavorite == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let imageOfBucketInside = product.isBucketInside == true ? UIImage(systemName: "cart.fill") : UIImage(systemName: "cart")
        let view = ProductDetailViewController(presenter: presenter,
                                               tableHandler: tableHandler,
                                               imageOfFavorite: imageOfFavorite,
                                               imageOfBucket: imageOfBucketInside
        )
        
        subject?.add(interactor)
        interactor.subject = subject
        interactor.output = interactor
        interactor.outputToPresenter = presenter
        presenter.view = view
        return view
    }
}
