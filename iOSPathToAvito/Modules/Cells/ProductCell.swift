import UIKit

public protocol ProductCellDelegate: AnyObject {

    func change(product: [UUID: Product])
    
    func showDetail(product: Product)
}

public protocol ProductCellProtocol {
    func setDelegate(_ delegate: ProductCellDelegate?)
}

public class ProductCell: UITableViewCell {
    
    private weak var delegate: ProductCellDelegate?
    
    private var stateOfFavorite: StateButton = .unpressed
    private var stateOfBucket: StateButton = .unpressed
    
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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        toBucketButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toBucketButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            toBucketButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            toBucketButton.heightAnchor.constraint(lessThanOrEqualToConstant: 20),
            toBucketButton.widthAnchor.constraint(lessThanOrEqualToConstant: 20)
        ])
        
        toFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toFavoritesButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            toFavoritesButton.trailingAnchor.constraint(equalTo: toBucketButton.leadingAnchor, constant: -10),
            toFavoritesButton.heightAnchor.constraint(lessThanOrEqualToConstant: 20),
            toFavoritesButton.widthAnchor.constraint(lessThanOrEqualToConstant: 20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toFavoritesWasClicked() {
        let image = stateOfFavorite == .unpressed ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        toFavoritesButton.setImage(image, for: .normal)
        stateOfFavorite = stateOfFavorite == .unpressed ? .pressed : .unpressed
        
        if let product = product,
        let id = product.id {
            product.isFavorite = !product.isFavorite
            delegate?.change(product: [id: product])
        }
    }
    
    @objc private func toBucketWasClicked() {
        let image = stateOfBucket == .unpressed ? UIImage(systemName: "cart.fill") : UIImage(systemName: "cart")
        toBucketButton.setImage(image, for: .normal)
        stateOfBucket = stateOfBucket == .unpressed ? .pressed : .unpressed
        
        if let product = product,
        let id = product.id {
            product.isBucketInside = !product.isBucketInside
            delegate?.change(product: [id: product])
        }
    }
}
