//
//  UITableViewExtension.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation
import UIKit

extension UITableView {
    
    /// Just a tad neater cell dequeueing
    /// - Parameters:
    ///   - type: Cell type
    ///   - indexPath: indexPath
    /// - Returns: UITableviewCell of the given generic class
    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type, for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: "\(type)", for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
