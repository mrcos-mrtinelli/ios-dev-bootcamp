//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find cork", "Take it to a person", "Fetch when they throw it"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        addNewItemButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = addNewItemButton
    }
    
    //MARK: - TableView Datasource Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @objc func addNewItem() {
        let ac = UIAlertController(title: "Add New To Do", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submit = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            if let input = ac?.textFields?.first?.text {
                guard let self = self else { return }
                self.itemArray.append(input)
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.itemArray.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            }
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Add New To Do"
        }
        
        ac.addAction(cancel)
        ac.addAction(submit)
        
        present(ac, animated: true)
    }
}

