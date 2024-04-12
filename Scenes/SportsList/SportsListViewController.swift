//
//  ViewController.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import UIKit

// TODO: rename
final class SportsListViewController: UIViewController {

    @IBOutlet private weak var sportsCatalogTableView: UITableView!
    
    private var cellModels: [ConfigurableTableViewCellModel] = []
    private var sportsCatalog: [SportModel] = [] // TODO: Get from View model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sports"
        
        sportsCatalogTableView.register(
            UINib(nibName: "\(CatalogTableViewCell.self)",bundle: nil),
            forCellReuseIdentifier: "\(CatalogTableViewCell.self)"
        )
        
        Task {
            do {
                let sportsRequest = SportsRequest()
                let response = try await APIManager().execute(request: sportsRequest, expectedType: SportsResponseModel.self)
                let sportsList = response.data.data
                cellModels = sportsList.map({ sport in
                    return CatalogTableViewCellModel(sportName: sport.name)
                })
                sportsCatalog = sportsList
                sportsCatalogTableView.reloadData()
                print(sportsList)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension SportsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: move this and make initializer with viewmodel
        let sportDetailsViewModel = SportDetailsViewModel(sportModel: sportsCatalog[indexPath.row]) // TODO: safe index
        let detailsVC = SportDetailsViewController(viewModel: sportDetailsViewModel)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}


extension SportsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = cellModels[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(of: cellModel.cellType, for: indexPath) else {
            return UITableViewCell()
        }
        
        (cell as? ConfigurableTableViewCell)?.configure(with: cellModel)
        return cell
    }
    
}
