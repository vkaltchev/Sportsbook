//
//  SportsCatalogViewController.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 14.04.24.
//

import UIKit
import Combine

// TODO: rename
final class SportsCatalogueViewController: BaseViewController<SportsCatalogueViewModel> {
    
    @IBOutlet private weak var sportsCatalogTableView: UITableView!

    private var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sports"
        add(refreshControl: UIRefreshControl(), to: sportsCatalogTableView)
        
        sportsCatalogTableView.register(
            UINib(nibName: "\(CatalogTableViewCell.self)",bundle: nil),
            forCellReuseIdentifier: "\(CatalogTableViewCell.self)"
        )
        
        bindViews(with: viewModel)
    }
    
    private func bindViews(with viewModel: SportsCatalogueViewModel) {
        viewModel.$loadingState
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                switch viewModel.loadingState {
                case .loading:
                    self?.sportsCatalogTableView.refreshControl?.beginRefreshing()
                case .finished:
                    self?.sportsCatalogTableView.refreshControl?.endRefreshing()
                case .error(let apiError):
                    self?.showError(message: apiError.localizedDescription)
                    self?.sportsCatalogTableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &bindings)
        
        viewModel.$cellModels
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.sportsCatalogTableView.reloadData()
            }
            .store(in: &bindings)
    }
    
    @objc private func didPullToRefresh(control: UIRefreshControl) {
        viewModel.fetchSportsCatalogue()
    }
    
    // TODO: Perhaps move these in BaseVC class
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert) // TODO: add default message/title and move hardcoded strings from here
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func add(refreshControl: UIRefreshControl, to tableView: UITableView) {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(control:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// ****************************************
// MARK: TableView Datasource and Delegate
// ****************************************

extension SportsCatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = viewModel.sportsCatalogue[safe: indexPath.row] else { return }
        viewModel.showSportDetails(for: model)
    }
}


extension SportsCatalogueViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.cellModels[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(of: cellModel.cellType, for: indexPath) else {
            return UITableViewCell()
        }
        
        (cell as? ConfigurableTableViewCell)?.configure(with: cellModel)
        return cell
    }
}
