import UIKit
public class ProductDetailTableHandler: NSObject {
    var currentProduct: Product?
}

extension ProductDetailTableHandler: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ProductCellDetail = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCellDetail.self),
                                                              for: indexPath) as? ProductCellDetail else {
            return UITableViewCell()
        }

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Название"
            cell.detailTextLabel?.text = currentProduct?.title
        case 1:
            cell.textLabel?.text = "Описание"
            cell.detailTextLabel?.text = currentProduct?.productDescription
        case 2:
            cell.textLabel?.text = "Цена"
            cell.detailTextLabel?.text = currentProduct?.title
        default:
            return cell
        }
        return cell
    }
}
