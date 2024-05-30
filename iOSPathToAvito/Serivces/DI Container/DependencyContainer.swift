
public final class DependencyContainer {
    
    public static let shared = DependencyContainer()
    
    private var weakDependencies = [String: WeakContainer]()
    
    private func getWeak<T: AnyObject>(
        initialize: () -> T
    ) -> T {
        let id = String(
            describing: T.self
        )
        
        if let dependency = weakDependencies[id]?.object as? T {
            return dependency
        }
        
        let object = initialize()
        weakDependencies[id] = .init(
            object: object
        )
        
        return object
    }
    
    private init() { }
    
    public func mareCoreDataRequestService() -> DataRequestService {
        return getWeak {
            let coreDataAssembler: CoreDataAssemblerProtocol = CoreDataAssembler()
            return DataRequestService(coreDataAssembler: coreDataAssembler)
        }
    }
    
    public func makeProductDataService() -> ProductDataService {
        return getWeak {
            let localLoader: LocalLoaderProtocol = LocalLoader()
            let dataRequestService: CoreDataServiceProtocol = mareCoreDataRequestService()
            let localRepository = ProductLocalFileRepository(localLoader: localLoader,
                                                             coreDataService: dataRequestService)
            let coreDataRepository = ProductCoreDataRepository(coreDataRequestService: dataRequestService)
            let cacheRepository = ProductCacheRepository()
            return ProductDataService(
                productLocalFileRepository: localRepository,
                productCoreDataRepository: coreDataRepository,
                productCacheRepository: cacheRepository
            )
        }
    }
}
