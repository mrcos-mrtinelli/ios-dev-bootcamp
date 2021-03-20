//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Marcos Martinelli on 3/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }

    
    //MARK: - Functions
    @IBAction func addButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let self = self else { return }
            
            if let categoryName = ac?.textFields?.first?.text {
                
                let newCategory = Category(context: self.context)
                newCategory.name = categoryName
                
                self.categories.append(newCategory)
                
                guard self.saveCategories() else { return }
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.categories.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        ac.addTextField()
        ac.addAction(cancel)
        ac.addAction(submit)
        
        present(ac, animated: true)
    }
    
    //MARK: - Data Functions
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error retrieving categories: \(error)")
        }
        
        tableView.reloadData()
    }
    func saveCategories() -> Bool {
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
            return false
        }
        return true
    }
}
