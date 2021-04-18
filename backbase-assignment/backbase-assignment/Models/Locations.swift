//
//  Locations.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

struct Location: Codable {
    let country: String
    let name: String
    let id: Int
    let coordinates: Coordinates

    struct Coordinates: Codable {
        let longitude: Double
        let latitude: Double

        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }


    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coordinates = "coord"
    }

    /// A 'name' string to display to humans (helper for table cells, titles, etc)
    public func getDisplayName() -> String {
        "\(name), \(country)"
    }

    /// A 'coordinated' string to display to humans (helper for table cells etc)
    public func getCoordinatesString() -> String {
        "(\(coordinates.latitude), \(coordinates.longitude))"
    }

    /// A normalized key to use for searching, this is not guaranteed to be unique
    public func getKey() -> String {
        "\(name),\(country)".normalizeForSearch()
    }
}

extension Location: Comparable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Location, rhs: Location) -> Bool {
        lhs.getDisplayName() < rhs.getDisplayName()
    }

    static func > (lhs: Location, rhs: Location) -> Bool {
        lhs.getDisplayName() > rhs.getDisplayName()
    }
}
