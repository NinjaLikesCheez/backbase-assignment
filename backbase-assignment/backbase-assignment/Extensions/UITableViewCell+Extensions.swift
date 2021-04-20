//
//  UITableViewCell+Extensions.swift
//  backbase-assignment
//
//  Created by ninja on 18/04/2021.
//

import UIKit

extension UITableViewCell {
    /// Configures a cell to display a location
    ///
    /// - Note: Normally I'd _never_ do this in a code base and would instead create a cell subclass. However, this project only relies on one cell and has a tight scope
    func configureLocationCell(_ location: Location) {
        let text = location.displayName
        let secondaryText = location.coordinates.displayName
        let secondaryTextColor = UIColor.secondaryLabel

        if #available(iOS 14.0, *) {
            var configuration = self.defaultContentConfiguration()
            configuration.text = text
            configuration.secondaryText = secondaryText
            configuration.secondaryTextProperties.color = secondaryTextColor

            self.contentConfiguration = configuration
        } else {
            self.textLabel?.text = text
            self.detailTextLabel?.text = secondaryText
            self.detailTextLabel?.textColor = secondaryTextColor
        }

        self.accessoryType = .disclosureIndicator
    }
}

