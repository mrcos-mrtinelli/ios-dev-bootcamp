import Foundation

// Part 1 - how much paint is needed to paint the wall?
// each bucket cover 1.5 meters squared
// * measurements are metric

var width: Float = 1.5
var height: Float = 2.3
var areaCoveredPerBucket: Float = 1.5

var numberOfBuckets: Int {
    // part 1
    get {
        let area = width * height
        let result = area / areaCoveredPerBucket
        return Int(ceilf(result))
    }
    // part 2
    set {
        let totalAreaCovered = areaCoveredPerBucket * Float(newValue)
        print("you can paint a total of \(totalAreaCovered) meters squared")
    }
}

print("you need \(numberOfBuckets) buckets to paint the wall")

// Part 2 - what is the total area that can be covered.
numberOfBuckets = 3
