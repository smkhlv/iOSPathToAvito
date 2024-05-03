import Foundation

protocol ProductDetailPresenterProtocol: AnyObject { 
    func updateProduct(_ product: Product)
    
    func showProduct()
    
    func changeIsFavorite()
    
    func changeIsBucketInside()
}

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    public weak var view: ProductDetailViewControllerProtocol?
    
    private let interactor: ProductDetailInteractorInput
    
    init(interactor: ProductDetailInteractorInput) {
        self.interactor = interactor
    }
    
    func updateProduct(_ product: Product) {
        interactor.updateProduct(product)
    }
    
    func showProduct() {
        interactor.showProduct() 
    }
    
    func changeIsFavorite() {
        interactor.changeIsFavorite()
    }
    
    func changeIsBucketInside() {
        interactor.changeIsBucketInside()
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutput {
    func showProduct(_ product: Product) {
        view?.updateDetail(product)
    }
}

