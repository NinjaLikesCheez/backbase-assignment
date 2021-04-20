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
* For the best efficiency, use a `Release` build. 

## Decisions

The data structure I chose to optimize for searching was a radix binary search tree, this seemed a good fit for the brief. 

Initially I implemented a prefix binary search tree, which generated over 1 million nodes - it seemed excessive so I thought about ways to compress the size of the tree, radix BST seemed the best way to achieve this.

It takes a `Location` to insert into the tree, takes the `displayName` (which is `name, country` lowercased), and will create a `RadixNode` for each common prefix across all other objects. When we reach a 'termination' node we will insert the `Location` into that node, this means we can have multiple `Location`s for a given key and allows us to look up keys in `O(k)` where `k` is the length of the search key.

When inserting into the tree, both `children` and `locations` are inserted in a sorted order (by using a divide and conquer method of finding an appropriate insertion index), this allows us to assume that location lookups will be presorted and don't need to do it for every search (because we use a postfix lookup method for the children, we will find the locations from children in the sorted order they were inserted). 

I chose not to remove non-alphanumeric characters nor to normalize things like smart quotes to allow the user to be more specific in their queries, i.e. `Amsterdam-` will not match `Amsterdam` and will return only `Amsterdam-Zuidoost, NL`.

I also chose to interpret the `Compatible with the 2 latest versions of iOS` as `2 latest major versions` so the deployment target for this application is iOS 13.
