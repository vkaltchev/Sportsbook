//
//  UITableViewCellExtension.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation
import UIKit

// *****************************************
// MARK: Configurable
// *****************************************

protocol ConfigurableTableViewCell: UITableViewCell {
    func configure(with model: ConfigurableTableViewCellModel)
}

/// Helps create simple TableViews datasource logic, free of if statements in the delegate and only based on view models
protocol ConfigurableTableViewCellModel {
    var cellType: UITableViewCell.Type { get }
}
