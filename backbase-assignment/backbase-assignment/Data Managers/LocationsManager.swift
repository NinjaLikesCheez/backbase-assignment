//
//  LocationsManager.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

typealias Locations = [Location]

protocol LocationsManagerDelegate: AnyObject {
    func locationsDidUpdate(_ locations: Locations)
}

class LocationsManager {
    static let instance = LocationsManager()
    static private let fileName = "cities"
    static private let sortedFileName = "\(LocationsManager.fileName)-sorted"
    static private let fileExtension = "json"

    let fileManager = FileManager.default

    /// Path on disk to the original data source
    var defaultPath: URL

    /// Path on disk to the cached data source
    var cachedPath: URL

    /// A binary search tree to optimize location searches
    private var tree = SearchTree()

    private var radixTree = RadixTree()

    
    var locations: Locations = [] {
        didSet {
            #if DEBUG
            let start = CFAbsoluteTimeGetCurrent()
            #endif

            // Clear and repopulate the tree
            radixTree = RadixTree()
            locations.forEach { radixTree.insert($0) }
//            tree = SearchTree()
//            locations.forEach { tree.insert($0) }

            #if DEBUG
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("Generated tree of \(tree.count) nodes in \(diff) seconds")
            #endif

            delegate?.locationsDidUpdate(locations)
        }
    }

    weak var delegate: LocationsManagerDelegate?

    private init() {
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

        getLocations {
            self.locations = $0
        }
    }

    private func decodeLocations(atURL url: URL) throws -> Locations {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Locations.self, from: data)
    }

    private func encode(_ locations: Locations, toURL url: URL) throws {
        let data = try JSONEncoder().encode(locations)
        try data.write(to: url)
    }

    // MARK: - Public Functions
    public func search(_ key: String) -> Locations {
        let node = tree.search(key)
        return tree.getReachingLocationsFromNode(node).sorted()
    }

    /// Parses `Locations` from the data source. On first run, this function will sort the keys and write a cache file
    /// - Parameter completionHandler: handler run after locations have been decoded
    public func getLocations(completionHandler: @escaping (Locations) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.fileManager.fileExists(atPath: self.cachedPath.path) {
                do {
                    let locations = try self.decodeLocations(atURL: self.cachedPath)

                    DispatchQueue.main.async {
                        completionHandler(locations)
                    }
                } catch {
                    fatalError("Failed to decode cached locations at path: \(self.cachedPath) with error: \(error)")
                }

                return
            }

            // Sort the locations, write to cache file to squeek out some fast load time.
            // (basically negligable, but every little helps)
            do {
                var locations = try self.decodeLocations(atURL: self.defaultPath)
                locations.sort { $0.key < $1.key }

                DispatchQueue.main.async {
                    completionHandler(locations)
                }

                do {
                    try self.encode(locations, toURL: self.cachedPath)
                } catch {
                    fatalError("Failed to encode locations to path: \(self.cachedPath.path) with error: \(error)")
                }
            } catch {
                fatalError("Failed to decode locations at path: \(self.defaultPath) with error: \(error)")
            }
        }
    }
}
