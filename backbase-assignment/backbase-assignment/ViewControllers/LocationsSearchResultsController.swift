//
//  LocationsSearchResultsController.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import UIKit

/// A table view to show search results
class LocationsSearchResultsController: UITableViewController {
    /// The data models for this table view
    var results: Locations = [] {
        didSet {
            tableView.reloadData()
        }
    }

    static private let reuseIdentifier = "\(String(describing: self))CellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: LocationsSearchResultsController.reuseIdentifier
        )
        tableView.delegate = self
    }

    private func deselectSelectedRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }
}

extension LocationsSearchResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationsSearchResultsController.reuseIdentifier,
            for: indexPath
        )

        let location = results[indexPath.row]
        cell.configureLocationCell(location)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results[indexPath.row]
        let viewController = MapViewController(result)

        presentingViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
