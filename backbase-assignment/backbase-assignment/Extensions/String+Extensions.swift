//
//  String+Extensions.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

extension String {
    /// Creates a normalized string optimized for inserting & searching a binary tree
    func normalizeForSearch() -> String {
        self.lowercased()
            .filter { !$0.isWhitespace }
    }
}
