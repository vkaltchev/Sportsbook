//
//  BaseViewController.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 12.04.24.
//

import Foundation
import UIKit

protocol BaseViewControllerProtocol: UIViewController {
    associatedtype ViewModelType
    init(viewModel: ViewModelType)
}

class BaseViewController<ViewModelType>: UIViewController, BaseViewControllerProtocol {
    let viewModel: ViewModelType
    
    convenience init() {
        fatalError("No implementation for init(). Use init(viewmodel:) instead.")
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("No implementation for init(coder:). Use init(viewmodel:) instead." )
    }
    
    required init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
}
                
