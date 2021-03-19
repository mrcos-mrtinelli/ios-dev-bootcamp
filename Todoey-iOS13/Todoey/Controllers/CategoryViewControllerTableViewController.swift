//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Marcos Martinelli on 3/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class CategoryViewControllerTableViewController: UITableViewController {
    
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    @IBAction func addButtonTapped(_ sender: Any) {
    }
}
