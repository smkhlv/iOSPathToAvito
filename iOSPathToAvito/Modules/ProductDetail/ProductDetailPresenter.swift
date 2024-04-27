import Foundation

protocol ProductDetailPresenterProtocol: AnyObject { }

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    public weak var view: ProductDetailViewControllerProtocol?
}

