//
//  SportDetailsViewController.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 6.04.24.
//

import UIKit
import SwiftUI


struct SportsEventMarketSectionModel {
    let dateString: String
    var cellModels: [ConfigurableTableViewCellModel] = []
}

final class SportDetailsViewController: UIViewController {
    
    private let dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        return formatter
    }()
    
    private var sportsEventMarketTableModel: [SportsEventMarketSectionModel] = []
    private var cellModels: [ConfigurableTableViewCellModel] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var data: [EventPrimaryMarketAggregate] = []
    var sportModel: SportModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = sportModel.name
        
        tableView.register(
            UINib(nibName: "\(SportDetailsTableViewCell.self)",bundle: nil),
            forCellReuseIdentifier: "\(SportDetailsTableViewCell.self)"
        )

        // TODO: Move this in a view model/repository
        Task {
            do {
                let sportEventRequest = SportsDetailEventsRequest(sportId: sportModel.id)
                let response = try await APIManager().execute(
                    request: sportEventRequest,
                    expectedType: SportDetailEventsResponseModel.self
                )
                let sportsList = response.data.data
                data = sportsList
                print("Sports list details: \(sportsList)")
                sportsList.forEach { eventMarketData in
                    let sectionModel = SportsEventMarketSectionModel(dateString: eventMarketData.date.formattedWithSuffix())
                    if !sportsEventMarketTableModel.contains(where: { section in
                        section.dateString == sectionModel.dateString
                    }) {
                        sportsEventMarketTableModel.append(sectionModel)
                    }
                }
          
                sportsEventMarketTableModel = sportsEventMarketTableModel.map({ sectionModel in
                    var cellModelsForSection: [ConfigurableTableViewCellModel] = []
                    sportsList.forEach { eventMarketData in
                        if sectionModel.dateString == eventMarketData.date.formattedWithSuffix() {
                            cellModelsForSection.append(SportDetailsTableViewCellModel(eventMarketData: eventMarketData))
                        }
                    }
                    return SportsEventMarketSectionModel(dateString: sectionModel.dateString, cellModels: cellModelsForSection)
                })
                
                tableView.reloadData()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}


extension SportDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sportsEventMarketTableModel[section].dateString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sportsEventMarketTableModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sportsEventMarketTableModel[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = sportsEventMarketTableModel[indexPath.section].cellModels[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(of: cellModel.cellType, for: indexPath) else {
            return UITableViewCell()
        }
        
        (cell as? ConfigurableTableViewCell)?.configure(with: cellModel)
        return cell
    }
    
}

// TODO: Move
// TODO: Check if needed - perhaps in the cells setup
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// TODO: Move?
extension Date {

    // TODO: refactor and move this as a helper out of Date.
    func formattedWithSuffix() -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE d'\(self.daySuffix())' MMMM"
        
        return formatter.string(from: self)
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}


struct GenericUIKitViewRepresentable<UIView: UIKit.UIView>: UIViewRepresentable {
    let uiViewType: UIView.Type
    let configuration: (UIView) -> ()

    func makeUIView(context: Context) -> UIView {
        uiViewType.init()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        configuration(uiView)
    }
}


struct ViewDatePreview: PreviewProvider {
    
    static var previews: some View {
        SportDetailsVCRepresentable()
    }
}

struct SportDetailsVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SportDetailsViewController {
        let vc =  SportDetailsViewController()
        vc.sportModel = SportModel(id: 1, name: "Football")
        return vc
    }

    func updateUIViewController(_ uiViewController: SportDetailsViewController, context: Context) {
        // do nothing
    }

    typealias UIViewControllerType = SportDetailsViewController

}

