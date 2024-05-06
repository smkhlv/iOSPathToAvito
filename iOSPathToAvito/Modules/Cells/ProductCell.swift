import UIKit

// Delegate protocol for interacting with ProductCell actions
public protocol ProductCellDelegate: AnyObject {
    // Method called when the favorite or bucket state of a product changes
    func change(product: [UUID: Product])
    
    // Method called when a product detail is requested
    func showDetail(product: Product)
}

// Protocol defining the methods required for a ProductCell
public protocol ProductCellProtocol {
    // Method to set the delegate for the ProductCell
    func setDelegate(_ delegate: ProductCellDelegate?)
}

public class ProductCell: UITableViewCell {
    
    enum Constants {
        // Static numbers
        enum Numbers {
            static let buttonSize: CGFloat = 20
            static let leadingMargin: CGFloat = 20
            static let trailingBucketMargin: CGFloat = -20
            static let trailingFavoriteMargin: CGFloat = -10
            static let spacingBetweenButtons: CGFloat = 10
        }
    }
    
    private weak var delegate: ProductCellDelegate?
    private var product: Product?
    
    private lazy var toBucketButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self,
                         action: #selector(toBucketWasClicked),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var toFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self,
                         action: #selector(toFavoritesWasClicked),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    public func configureCell(delegate: ProductCellDelegate?, 
                              product: Product,
                              imageOfFavorite: UIImage?,
                              imageOfBucket: UIImage?) {
        self.delegate = delegate
        self.product = product
        self.titleLabel.text = product.title
        
        toFavoritesButton.setImage(imageOfFavorite, for: .normal)
        toBucketButton.setImage(imageOfBucket, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    private func setupCell () {
        
        contentView.addSubview(toBucketButton)
        contentView.addSubview(toFavoritesButton)
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, 
                                                constant: Constants.Numbers.leadingMargin)
        ])
        
        toBucketButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toBucketButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            toBucketButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: Constants.Numbers.trailingBucketMargin),
            toBucketButton.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.Numbers.buttonSize),
            toBucketButton.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.Numbers.buttonSize)
        ])
        
        toFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toFavoritesButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            toFavoritesButton.trailingAnchor.constraint(equalTo: toBucketButton.leadingAnchor,
                                                        constant: Constants.Numbers.trailingFavoriteMargin),
            toFavoritesButton.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.Numbers.buttonSize),
            toFavoritesButton.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.Numbers.buttonSize)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toFavoritesWasClicked() {
        guard
            let product = product,
            let id = product.id else {
            return
        }
        let image = !product.isFavorite ?
        UIImage(systemName: PublicConstants.SystemImages.heartFill) :
        UIImage(systemName: PublicConstants.SystemImages.heart)
        
        toFavoritesButton.setImage(image, for: .normal)
        
        product.isFavorite = !product.isFavorite
        delegate?.change(product: [id: product])
    }
    
    @objc private func toBucketWasClicked() {
        guard
            let product = product,
            let id = product.id else {
            return
        }
        let image = !product.isBucketInside ?
        UIImage(systemName: PublicConstants.SystemImages.cartFill) :
        UIImage(systemName: PublicConstants.SystemImages.cart)
        
        toBucketButton.setImage(image, for: .normal)

        product.isBucketInside = !product.isBucketInside
        delegate?.change(product: [id: product])
    }
}
