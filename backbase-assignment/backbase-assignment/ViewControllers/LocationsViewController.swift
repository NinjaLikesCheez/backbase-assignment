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

    private var locations: Locations = [] {
        didSet {
            // TODO: Animate this
            print("Setting locations")
            tableView.reloadData()
        }
    }

    private var locationsManager = LocationsManager()

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
        locationsManager.getLocations {
            self.locations = $0
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
extension LocationsViewController: UISearchBarDelegate {

}

extension LocationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}

// MARK: - Table View Delegate Conformance
extension LocationsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectSelectedRow()
        let location = locations[indexPath.row]

        let viewController = MapViewController(location)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Table View DataSource Conformance
extension LocationsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Extract to custom cell?
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationsViewController.reuseIdentifier,
            for: indexPath
        )

        let location = locations[indexPath.row]

        let text = location.getDisplayName()
        let secondaryText = location.getCoordinatesString()
        let secondaryTextColor = UIColor.secondaryLabel

        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = text
            configuration.secondaryText = secondaryText
            configuration.secondaryTextProperties.color = secondaryTextColor

            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = text
            cell.detailTextLabel?.text = secondaryText
            cell.detailTextLabel?.textColor = secondaryTextColor
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }
}
