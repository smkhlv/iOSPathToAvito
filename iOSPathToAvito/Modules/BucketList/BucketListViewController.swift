import UIKit

public protocol BucketListViewControllerProtocol: AnyObject { }

public final class BucketListViewController: UIViewController,
                                             BucketListViewControllerProtocol {
    
    private let presenter: BucketListPresenterProtocol
    
    init(presenter: BucketListPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        presenter.viewDidLoad(view: self)
    }
}
