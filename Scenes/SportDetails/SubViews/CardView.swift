//
//  CardView.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 6.04.24.
//

import UIKit

final class CardView: UIView {
    
    // **********************************
    // MARK: - IBOutlets
    // **********************************
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var scoreComparisonLabel: UILabel!
    
    // **********************************
    // MARK: - Public methods
    // **********************************
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configure(with title: String, denominator: Int, numerator: Int) {
        titleLabel.text = title
        scoreComparisonLabel.text = "\(numerator) / \(denominator)"
    }
    
    // **********************************
    // MARK: - Private methods
    // **********************************
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
