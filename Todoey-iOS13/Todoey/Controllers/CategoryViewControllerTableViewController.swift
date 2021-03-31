//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Marcos Martinelli on 3/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewControllerTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let cellContent = categories?[indexPath.row] {
            cell.textLabel?.text = cellContent.name
            cell.backgroundColor = UIColor(hexString: cellContent.backgroundColor)
            
        } else {
            cell.textLabel?.text = "No categories found."
            cell.backgroundColor = UIColor.randomFlat()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    
    //MARK: - Functions
    @IBAction func addButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let self = self else { return }
            
            if let categoryName = ac?.textFields?.first?.text {
                
                let newCategory = Category()
                newCategory.name = categoryName
                newCategory.backgroundColor = UIColor.randomFlat().hexValue()
                
                self.saveCategories(category: newCategory)
            }
        }
        
        ac.addTextField { textField in
            textField.placeholder = "Enter your new category"
        }
        ac.addAction(cancel)
        ac.addAction(submit)
        
        present(ac, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("error saving context: \(error)")
        }
        
        guard let index = categories?.count else { return }
        let indexPath = IndexPath(row: index - 1, section: 0)

        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch  {
                print("an error occurred when deleting: \(error)")
            }
        }
    }
}

