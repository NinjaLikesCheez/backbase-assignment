//
//  LocationsSearchResultsController.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import UIKit

class LocationsSearchResultsController: UITableViewController {
    var results: Locations = [] {
        didSet {
            tableView.reloadData()
        }
    }

    static private let reuseIdentifier = "\(String(describing: self))CellReuseIdentifier"

    init() { super.init(nibName: nil, bundle: nil) }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: LocationsSearchResultsController.reuseIdentifier
        )
        tableView.delegate = self
    }

    override func loadView() { super.loadView() }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        // TODO: Extract to custom cell!!!
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationsSearchResultsController.reuseIdentifier,
            for: indexPath
        )

        let location = results[indexPath.row]

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results[indexPath.row]
        let viewController = MapViewController(result)

        presentingViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
