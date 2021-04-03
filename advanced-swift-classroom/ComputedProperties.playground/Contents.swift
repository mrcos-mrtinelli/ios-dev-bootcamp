import Foundation

// Pizza calculator to illustrate the use of computed properties.
 
var pizzaInInches: Int = 8
var numberOfPeople: Int = 10
var slicesPerPerson: Int = 4

// getter:
var numberOfSlices: Int {
    return pizzaInInches - 4
}

// setter
var numOfSlices: Int {
    get {
        return pizzaInInches - 4
    }
    set {
        print("the newValue is = \(newValue)")
    }
}


print(numberOfSlices)

print(numOfSlices)
numOfSlices = 6

// Observed Properties
// willSet and didSet

var pizzaInInch: Int = 10 {
    willSet {
        print("new value: \(newValue)")
    }
    didSet {
        if pizzaInInch > 18 {
            print("invalid pizza size, will set it to 18 inches")
        }
        print("was \(oldValue)")
        print(pizzaInInch)
    }
}
