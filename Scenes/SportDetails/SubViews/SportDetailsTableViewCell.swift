//
//  SportDetailsTableViewCell.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 6.04.24.
//

import UIKit

final class SportDetailsTableViewCell: UITableViewCell, ConfigurableTableViewCell {

    // **********************************
    // MARK: - IBOutlets
    // **********************************
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var homeTeamNameLabel: UILabel!
    @IBOutlet private weak var awayTeamNameLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var scoreCardsStackView: UIStackView!
    
    // **********************************
    // MARK: - Public methods
    // **********************************
    func configure(with model: ConfigurableTableViewCellModel) {
        guard let model = model as? SportDetailsTableViewCellModel else { return }
        
        separatorView.isHidden = !model.shouldShowSeparator
        typeLabel.text = model.marketName
        homeTeamNameLabel.text = model.homeTeamName
        awayTeamNameLabel.text = model.awayTeamName
        scoreCardsStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        model.runners.forEach { runner in
            
            let scoreCardView = CardView()
            let cardName: String
           
            if let runner = runner as? WDWMatchRunner {
                if runner.name == model.homeTeamName {
                    cardName = "Home"
                } else if runner.name == model.awayTeamName {
                    cardName = "Away"
                } else {
                    cardName = runner.name
                }
            } else if let runner = runner as? TotalGoalsInMatchRunner {
                cardName = "\(runner.totalGoals)"
            } else {
                fatalError("RunnerTypeNotFound")
            }
            
            scoreCardView.configure(
                with: cardName,
                denominator: runner.odds.denominator,
                numerator: runner.odds.numerator
            )
            
            scoreCardsStackView.addArrangedSubview(scoreCardView)
        }
    }
}
