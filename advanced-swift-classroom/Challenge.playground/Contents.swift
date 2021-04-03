import Foundation

// how much paint is needed to paint the wall?
// each bucket cover 1.5 meters squared
// * measurements are metric

var width: Float = 1.5
var height: Float = 2.3
var areaCoveredPerBucket: Float = 1.5

var numberOfBuckets: Int {
    
    get {
        let area = width * height
        return Int(area / areaCoveredPerBucket)
    }
}

print("you need \(numberOfBuckets) buckets to paint the wall")
