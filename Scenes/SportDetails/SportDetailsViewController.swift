//
//  SportDetailsViewController.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 6.04.24.
//

import UIKit
import SwiftUI
import Combine

final class SportDetailsViewController: BaseViewController<SportDetailsViewModel> {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.sportModel.name
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(control:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(
            UINib(nibName: "\(SportDetailsTableViewCell.self)",bundle: nil),
            forCellReuseIdentifier: "\(SportDetailsTableViewCell.self)"
        )
        
        bindViews(with: viewModel)
    }
    
    private func bindViews(with viewModel: SportDetailsViewModel) {
        // bind title label
        viewModel.$sportModel
            .receive(on: RunLoop.main)
            .sink { [weak self] sportModel in
                self?.title = sportModel.name
            }
            .store(in: &bindings)
        
        // bind loading state. TODO: Improve error handling
        viewModel.$loadingState
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                switch viewModel.loadingState {
                case .loading:
                    self?.tableView.refreshControl?.beginRefreshing()
                case .finished:
                    self?.tableView.refreshControl?.endRefreshing()
                case .error(let apiError):
                    self?.showError(message: apiError.localizedDescription)
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &bindings)
        
        // bind table view with datasource model
        viewModel.$sportsEventMarketTableModel
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &bindings)
    }
    
    @objc private func didPullToRefresh(control: UIRefreshControl) {
        viewModel.fetchAndTransformSportsEvents(forSportWith: viewModel.sportModel.id)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// *****************************
// MARK: TableViewDataSource
// *****************************

extension SportDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sportsEventMarketTableModel[section].dateString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sportsEventMarketTableModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sportsEventMarketTableModel[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.sportsEventMarketTableModel[indexPath.section].cellModels[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(of: cellModel.cellType, for: indexPath) else {
            return UITableViewCell()
        }
        
        (cell as? ConfigurableTableViewCell)?.configure(with: cellModel)
        return cell
    }
    
}

// *****************************
// MARK: Preview support
// *****************************

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
        let sportDetailsViewModel = SportDetailsViewModel(sportModel: SportModel(id: 1, name: "Football"))
        let detailsVC = SportDetailsViewController(viewModel: sportDetailsViewModel)
        return detailsVC
    }

    func updateUIViewController(_ uiViewController: SportDetailsViewController, context: Context) {
        // do nothing
    }

    typealias UIViewControllerType = SportDetailsViewController
}

