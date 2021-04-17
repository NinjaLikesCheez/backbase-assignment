//
//  LocationsViewController.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import UIKit

class LocationsViewController: UITableViewController {
    static private let reuseIdentifier = "\(String(describing: self))CellReuseIdentifier"

    private var searchController: UISearchController!
    private let resultsController = LocationsSearchResultsController()

    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Backbase"

        navigationItem.largeTitleDisplayMode = .always

        resultsController.tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
}

// MARK: - Searching Conformance
extension LocationsViewController: UISearchBarDelegate {

}

extension LocationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}

// MARK: - Table View Delegate Conformance
extension LocationsViewController {

}

// MARK: - Table View DataSource Conformance
extension LocationsViewController {

}
