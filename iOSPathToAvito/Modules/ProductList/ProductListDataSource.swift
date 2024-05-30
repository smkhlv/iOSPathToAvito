import UIKit

enum Section {
    case main
}


// Handles the table view data source and delegate methods for displaying products
public final class ProductListDataSource: NSObject {
    
    public weak var delegate: ProductCellDelegate?
    
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Product>!
    
    public func appendItems(products: [Product]) {
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func reloadItems(products: [Product]) {
        snapshot.reloadItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func deleteItems(products: [Product]) {
        snapshot.deleteItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func deleteAllItems() {
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func setupDataSource(table: UITableView) {
        
        dataSource = UITableViewDiffableDataSource(tableView: table) { [weak self] tableView, indexPath, product in
            guard
                let cell: ProductCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self),
                                                                  for: indexPath) as? ProductCell else {
                return UITableViewCell()
            }

            let imageOfFavorite = product.isFavorite ?
            UIImage(systemName: PublicConstants.SystemImages.heartFill) :
            UIImage(systemName: PublicConstants.SystemImages.heart)
            
            let imageOfBucket = product.isBucketInside ?
            UIImage(systemName: PublicConstants.SystemImages.cartFill) :
            UIImage(systemName: PublicConstants.SystemImages.cart)
            
            cell.configureCell(delegate: self?.delegate,
                               product: product,
                               imageOfFavorite: imageOfFavorite,
                               imageOfBucket: imageOfBucket)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ProductListDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.showDetail(product: product)
    }
}
