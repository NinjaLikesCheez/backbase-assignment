//
//  String+Extensions.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

extension String {
    func normalizeForSearch() -> String {
        self.lowercased()
            .filter { !$0.isWhitespace }
    }
}
