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

    /// A 'name' string to display to humans (helper for table cells, titles, etc)
    let displayName: String

    public init(name: String, country: String, id: Int, coordinates: Coordinates) {
        self.name = name
        self.country = country
        self.id = id
        self.coordinates = coordinates

        self.displayName = "\(name), \(country)"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decode(String.self, forKey: .country)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)

        displayName = "\(name), \(country)"
    }

    struct Coordinates: Codable {
        let longitude: Double
        let latitude: Double

        /// A 'coordinated' string to display to humans (helper for table cells etc)
        let displayName: String

        public init(longitude: Double, latitude: Double) {
            self.longitude = longitude
            self.latitude = latitude

            self.displayName = "(\(latitude), \(longitude))"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            longitude = try container.decode(Double.self, forKey: .longitude)
            latitude = try container.decode(Double.self, forKey: .latitude)

            displayName = "(\(latitude), \(longitude))"
        }

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
}

extension Location: Comparable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Location, rhs: Location) -> Bool {
        lhs.displayName < rhs.displayName
    }

    static func > (lhs: Location, rhs: Location) -> Bool {
        lhs.displayName > rhs.displayName
    }
}
