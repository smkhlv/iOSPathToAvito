//protocol ProductDetailInteractorInput: AnyObject {
//    // fetching some data
//    func getCurrentProduct()
//}
//
//protocol ProductDetailInteractorOutput: AnyObject {
//    // result of fetching
//    
//    func currentProduct(_ product: Result<Product, ProductDetailInteractorError>)
//}
//
//enum ProductDetailInteractorError: Error {
//    case productWasNil
//}
//
//public class ProductDetailInteractor: ProductDetailInteractorInput {
//    
//    weak var output: ProductDetailInteractorOutput?
//    
//    let product: Product?
//    
//    init(product: Product) {
//        self.product = product
//    }
//    
//    func getCurrentProduct() {
//        guard let product = product else {
//            output?.currentProduct(.failure(.productWasNil))
//            return
//        }
//        output?.currentProduct(.success(product))
//    }
//}
