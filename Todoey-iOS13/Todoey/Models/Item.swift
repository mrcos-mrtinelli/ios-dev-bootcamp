//
//  Items.swift
//  Todoey
//
//  Created by Marcos Martinelli on 3/23/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var timestamp = Date()
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
