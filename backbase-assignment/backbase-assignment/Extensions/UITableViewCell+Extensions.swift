//
//  UITableViewCell+Extensions.swift
//  backbase-assignment
//
//  Created by ninja on 18/04/2021.
//

import UIKit

extension UITableViewCell {
    func configureLocationCell(_ location: Location) {
        let text = location.getDisplayName()
        let secondaryText = location.getCoordinatesString()
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

