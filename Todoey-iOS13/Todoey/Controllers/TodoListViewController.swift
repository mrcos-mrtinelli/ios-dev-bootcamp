//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        addNewItemButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = addNewItemButton

        loadItems()
    }
    //MARK: - TableView Datasource Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        
        itemArray[indexPath.row].done.toggle()
        
        if saveItems() {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: - Add new items
    @objc func addNewItem() {
        let ac = UIAlertController(title: "Add New To Do", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submit = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            if let input = ac?.textFields?.first?.text {
                guard let self = self else { return }
                
                let newToDo = Item(context: self.context)
                newToDo.id = UUID().uuidString
                newToDo.title = input
                newToDo.done = false
            
                self.itemArray.append(newToDo)
                
                guard self.saveItems() else { return }
                
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
    
    //MARK: - Model Updates
    func saveItems() -> Bool {
        
        do {
            try context.save()
        } catch {
            print("Error saving context.")
            return false
        }
        return true
    }
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print("Error reading data from context: \(error)")
        }
    }
}

