//
//  AFile.swift
//  SwiftAccessLevels
//
//  Created by Angela Yu on 14/09/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class AClass {
    
    //Global variables, also called class properties.
    private var aPrivateProperty = "private property"
    
    fileprivate var aFilePrivateProperty = "fileprivate property"
    
    var anInternalProperty = "internal property"
    
    func methodA () {
        
//        var aLocalVariable = "local variable"
        
        //Step 1. Try to print aLocalVariable Here - Possible
//        print("Step 1 \(aLocalVariable) printed from methodA in AClass")
        
        //Step 3. Try to print aPrivateProperty Here
//        print("Step 3 \(aPrivateProperty) printed from methodA in AClass")
        
        //Step 6. Try to print aFilePrivateProperty Here
        print("\(aFilePrivateProperty) from methodA")
        //Step 9. Try to print anInternalProperty Here
        print(anInternalProperty)
    }
    
    func methodB () {
        
        //Step 2. Try to print aLocalVariable Here
        // not possible
        
        //Step 4. Try to print aPrivateProperty Here
//        print("Step 4 \(aPrivateProperty) printed from methodA in AClass")
    }
    
}

class AnotherClassInTheSameFile {
    
    init() {
        
        //Step 5. Try to print aPrivateProperty Here
        print("unable to print aPrivateProperty from AnotherClassInTheSameFile")
        //Step 7. Try to print aFilePrivateProperty Here
        print(AClass().aFilePrivateProperty)
    }
}

