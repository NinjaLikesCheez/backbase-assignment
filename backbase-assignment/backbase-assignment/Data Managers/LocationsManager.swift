//
//  LocationsManager.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

typealias Locations = [Location]

struct LocationsManager {
    static private let fileName = "cities"
    static private let sortedFileName = "\(LocationsManager.fileName)-sorted"
    static private let fileExtension = "json"

    let fileManager = FileManager.default

    /// Path on disk to the original data source
    var defaultPath: URL

    /// Path on disk to the cached data source
    var cachedPath: URL

    init() {
        guard
            let path = Bundle.main.url(
                forResource: LocationsManager.fileName,
                withExtension: LocationsManager.fileExtension
            )
        else {
            fatalError("Failed to find \(LocationsManager.fileName).\(LocationsManager.fileExtension) - please ensure it exists in the bundle.")
        }

        defaultPath = path

        guard
            let cachePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            fatalError("Failed to find the caches directory in the user domain.")
        }

        cachedPath = cachePath.appendingPathComponent(
            "\(LocationsManager.sortedFileName).\(LocationsManager.fileExtension)"
        )
    }

    private func decodeLocations(atURL url: URL) throws -> Locations {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Locations.self, from: data)
    }

    private func encode(_ locations: Locations, toURL url: URL) throws {
        let data = try JSONEncoder().encode(locations)
        try data.write(to: url)
    }

    /// Parses `Locations` from the data source. On first run, this function will sort the keys and write a cache file
    /// - Parameter completionHandler: handler run after locations have been decoded
    public func getLocations(completionHandler: @escaping (Locations) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            if fileManager.fileExists(atPath: cachedPath.path) {
                do {
                    let locations = try decodeLocations(atURL: cachedPath)

                    DispatchQueue.main.async {
                        completionHandler(locations)
                    }
                } catch {
                    fatalError("Failed to decode cached locations at path: \(cachedPath) with error: \(error)")
                }

                return
            }

            // Sort the locations, write to cache file to squeek out some fast load time.
            // (basically negligable, but every little helps)
            do {
                var locations = try decodeLocations(atURL: defaultPath)
                locations.sort { $0.getKey() < $1.getKey() }

                DispatchQueue.main.async {
                    completionHandler(locations)
                }

                do {
                    try encode(locations, toURL: cachedPath)
                } catch {
                    fatalError("Failed to encode locations to path: \(cachedPath.path) with error: \(error)")
                }
            } catch {
                fatalError("Failed to decode locations at path: \(defaultPath) with error: \(error)")
            }
        }
    }
}

extension LocationsManager {
    /// This function is the same as the the regular locations one, but doesn't rely on closures to make testing setup easier
    public func fetchLocations() -> Locations {
        if fileManager.fileExists(atPath: cachedPath.path) {
            do {
                return try decodeLocations(atURL: cachedPath)
            } catch {
                fatalError("Failed to decode cached locations at path: \(cachedPath) with error: \(error)")
            }
        }

        // Sort the locations, write to cache file to squeek out some fast load time.
        // (basically negligable, but every little helps)
        do {
            var locations = try decodeLocations(atURL: defaultPath)
            locations.sort { $0.getKey() < $1.getKey() }

            do {
                try encode(locations, toURL: cachedPath)
            } catch {
                fatalError("Failed to encode locations to path: \(cachedPath.path) with error: \(error)")
            }

            return locations
        } catch {
            fatalError("Failed to decode locations at path: \(defaultPath) with error: \(error)")
        }
    }
}
