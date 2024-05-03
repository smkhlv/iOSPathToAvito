import UIKit

public final class ProductListTableHandler: NSObject {
    var products: [UUID: Product]?
    
    public weak var delegate: ProductCellDelegate?
}

extension ProductListTableHandler: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let product = products?[indexPath.row],
            let cell: ProductCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self),
                                                              for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }

        let imageOfFavorite = product.value.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let imageOfBucket = product.value.isBucketInside ? UIImage(systemName: "cart.fill") : UIImage(systemName: "cart")
        
        cell.configureCell(delegate: delegate,
                           product: product.value,
                           imageOfFavorite: imageOfFavorite,
                           imageOfBucket: imageOfBucket)
        
        return cell
    }
}

extension ProductListTableHandler: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let product = products?[indexPath.row] else {
            return
        }
        
        delegate?.showDetail(product: product.value)
    }
}
