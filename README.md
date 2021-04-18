# backbase-assignment

See [Instructions for the test.md](here) for the assignment brief.

## How to run

### Requirements

* macOS machine (and optionally an iOS device)
* Xcode 12.4 (hasn't been tested with earlier versions)

### Running the app

* Open the `backbase-assignment.xcodeproj` in the `backbase-assignment` folder
* If running on a device, change the signing team in the project settings
* Build and Run

## Decisions

The data structure I chose to optimize for searching was a prefix binary search tree, this seemed a good fit for the brief.

It takes a `Location` to insert into the tree, normalizes the `key` variable (which is a string of the `name, country` lowercased, with whitespaces removed), adn creates a `Node` for each `Character` in the `key`. At the end of the string, it will attach the `Location` object and set the `Node` as a termination node, this allows us to have matching `key`s with different `Locations` and allows us to walk the tree fairly efficiently.

I chose not to remove non-alphanumeric characters nor to normalize things like smart quotes to allow the user to be more specific in their queries, i.e. `Amsterdam-` will not match `Amsterdam` and will return only `Amsterdam-Zuidoost, NL`. I did remove whitespace as it significantly drops the amount of nodes in the tree, (and therefore increases the speed of a search) and isn't super applicable to searching, i.e. `Lon      don, GB` will match `London, GB`.

I also chose to interpret the `Compatible with the 2 latest versions of iOS` as `2 latest major versions` so the deployment target for this application is iOS 13.
