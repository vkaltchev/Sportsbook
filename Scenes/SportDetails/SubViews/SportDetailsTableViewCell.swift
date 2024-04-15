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

// Move to separate file
struct SportDetailsTableViewCellModel: ConfigurableTableViewCellModel {
    
    let eventMarketData: EventPrimaryMarketAggregate
    var shouldShowSeparator: Bool = true
    var runners: [RunnerType] {
        eventMarketData.primaryMarket.runners
    }
    var homeTeamName: String {
        orderedTeamNames(from: eventMarketData.name)[0]
    }
    var awayTeamName: String {
        orderedTeamNames(from: eventMarketData.name)[1]
    }
    var marketName: String {
        eventMarketData.primaryMarket.displayName
    }
    
    var cellType: UITableViewCell.Type {
        SportDetailsTableViewCell.self
    }
}

extension SportDetailsTableViewCellModel {
    
    // Unfortunately the TOTAL_GOALS_IN_MATCH Market model doesn't provide a clean way to get the team names.
    // This is prone to braking the app if the string format is changed and will best be improved with an API change.
    // For now we'll also be using this as a source for Home and Away teams, though we can assume that we can also get that information also from the array of runners in the rest of the Market models.
    func orderedTeamNames(from matchName: String) -> [String] {
        
        // the match betting market uses "vs" as separator, while the other use "v"
        let teamNames = matchName.components(separatedBy: " vs ")
        return teamNames.count > 1 ? teamNames : matchName.components(separatedBy: " v ")
    }
}
