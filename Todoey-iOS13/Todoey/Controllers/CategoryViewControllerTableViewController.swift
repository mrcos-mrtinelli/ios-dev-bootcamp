//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Marcos Martinelli on 3/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewControllerTableViewController: UITableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
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
}

//MARK: - Extension
extension CategoryViewControllerTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete, by SwipeKit")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-icon")
        
        return [deleteAction]
    }
}
