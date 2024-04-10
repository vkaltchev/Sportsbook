//
//  CatalogTableViewCell.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 6.04.24.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell, ConfigurableTableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var sportNameLabel: UILabel!
    
    // MARK: - Public methods
    func configure(with model: ConfigurableTableViewCellModel) {
        guard let model = model as? CatalogTableViewCellModel else {
            return
        }
        sportNameLabel.text = model.sportName
    }
    
}

// TODO: Move to new file
struct CatalogTableViewCellModel: ConfigurableTableViewCellModel {
    
    let sportName: String
    
    var cellType: UITableViewCell.Type {
        CatalogTableViewCell.self
    }
}


extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type, for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: "\(type)", for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}

protocol ConfigurableTableViewCell: UITableViewCell {
    func configure(with model: ConfigurableTableViewCellModel)
}

protocol ConfigurableTableViewCellModel {
    var cellType: UITableViewCell.Type { get }
}
