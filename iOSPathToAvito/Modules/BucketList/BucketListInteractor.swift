protocol BucketListInteractorInput: AnyObject {
    // fetching some data
}

protocol BucketListInteractorOutput: AnyObject {
    // result of fetching
}

final class BucketListInteractor: BucketListInteractorInput {
    
    weak var output: BucketListInteractorOutput?
}
