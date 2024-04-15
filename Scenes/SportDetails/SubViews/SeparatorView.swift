//
//  SeparatorView.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 13.04.24.
//

import UIKit

class SeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
    }
}
