//
//  Locations.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

struct Coordinates: Codable {
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Location: Codable {
    let country: String
    let name: String
    let id: Int
    let coordinates: Coordinates

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coordinates = "coord"
    }

    public func getDisplayName() -> String {
        "\(name), \(country)"
    }

    public func getCoordinatesString() -> String {
        "(\(coordinates.latitude), \(coordinates.longitude))"
    }

    public func getKey() -> String {
        "\(name)\(country)".normalizeForSearch()
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
