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

    var defaultPath: URL
    var sortedPath: URL

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

        sortedPath = cachePath.appendingPathComponent(
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

    public func getLocations(completionHandler: @escaping (Locations) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            if fileManager.fileExists(atPath: sortedPath.path) {
                do {
                    let locations = try decodeLocations(atURL: sortedPath)

                    DispatchQueue.main.async {
                        completionHandler(locations)
                    }
                } catch {
                    fatalError("Failed to decode cached locations at path: \(sortedPath) with error: \(error)")
                }

                return
            }

            // Sort the locations, write to cache file to squeek out some fast load time (basically negligable, but every little helps)
            var locations = try! decodeLocations(atURL: defaultPath)
            locations.sort { $0.getDisplayName() < $1.getDisplayName() }

            DispatchQueue.main.async {
                completionHandler(locations)
            }

            do {
                try encode(locations, toURL: sortedPath)
            } catch {
                fatalError("Failed to encode locations to path: \(sortedPath.path) with error: \(error)")
            }
        }
    }
}
