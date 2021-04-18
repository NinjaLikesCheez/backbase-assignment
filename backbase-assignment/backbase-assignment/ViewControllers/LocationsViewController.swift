//
//  LocationsViewController.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import UIKit

class LocationsViewController: UITableViewController {
    static private let reuseIdentifier = "\(String(describing: self))CellReuseIdentifier"

    /// Responsible for controlling the search bar and dispatching requests to update the results
    private var searchController: UISearchController!

    /// Shows the search results
    private let resultsController = LocationsSearchResultsController()

    /// A loading view shown when initially processing data before we have anything to show the user
    private var loadingViewController: LoadingViewController? = {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalTransitionStyle = .crossDissolve
        loadingViewController.modalPresentationStyle = .overFullScreen
        return loadingViewController
    }()

    private let manager = LocationsManager.instance

    /// A queue to run searches on (via the `searchWorkItem`)
    private let searchQueue = DispatchQueue(label: "Search Queue", qos: .userInitiated)

    /// A work item that encapsulates a searching operation
    private var searchWorkItem: DispatchWorkItem?

    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Backbase"

        navigationItem.largeTitleDisplayMode = .always
        manager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let viewController = loadingViewController {
            navigationController?.present(viewController, animated: true)
        }
    }

    override func loadView() {
        super.loadView()

        setup()
    }

    // MARK: - Setup Functions
    private func setup() {
        setupSearchController()
        setupTableView()
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.searchTextField.smartQuotesType = .no
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationsViewController.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func deselectSelectedRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }
}

// MARK: - Searching Conformance
extension LocationsViewController: UISearchBarDelegate { }

extension LocationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchWorkItem != nil {
            searchWorkItem?.cancel()
            searchWorkItem = nil
        }

        guard
            let searchText = searchController.searchBar.text,
            !searchText.isEmpty
        else { return }

        searchWorkItem = DispatchWorkItem {
            let results = self.manager.search(searchText)

            DispatchQueue.main.async {
                if let resultsController = self.searchController.searchResultsController as? LocationsSearchResultsController {
                    resultsController.results = results
                }
            }
        }

        // Offload searching to a background thread so we don't lock up the UI
        searchQueue.async(execute: searchWorkItem!)
    }
}

// MARK: - Table View Delegate Conformance
extension LocationsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectSelectedRow()
        let location = manager.locations[indexPath.row]

        let viewController = MapViewController(location)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Table View DataSource Conformance
extension LocationsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationsViewController.reuseIdentifier,
            for: indexPath
        )
        
        let location = manager.locations[indexPath.row]
        cell.configureLocationCell(location)

        return cell
    }
}

extension LocationsViewController: LocationsManagerDelegate {
    func locationsDidUpdate(_ locations: Locations) {
        tableView.reloadData()

        loadingViewController?.dismiss(animated: true)
        loadingViewController = nil
    }
}
