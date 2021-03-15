//
//  ToDoItem.swift
//  Todoey
//
//  Created by Marcos Martinelli on 3/13/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct ToDoItem: Codable {
    let id: String
    var done: Bool
    var todo: String
}
