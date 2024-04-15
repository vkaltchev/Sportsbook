//
//  CatalogTableViewCell.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 6.04.24.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell, ConfigurableTableViewCell {

    // **********************************
    // MARK: - IBOutlets
    // **********************************
    @IBOutlet private weak var separatorView: SeparatorView!
    @IBOutlet private weak var sportNameLabel: UILabel!
    
    // **********************************
    // MARK: - Public methods
    // **********************************
    func configure(with model: ConfigurableTableViewCellModel) {
        guard let model = model as? CatalogTableViewCellModel else {
            return
        }
        separatorView.isHidden = !model.shouldShowSeparator
        sportNameLabel.text = model.sportName
    }
}

// TODO: Move to new file
struct CatalogTableViewCellModel: ConfigurableTableViewCellModel {
    
    let sportName: String
    let shouldShowSeparator: Bool
    
    var cellType: UITableViewCell.Type {
        CatalogTableViewCell.self
    }
}
