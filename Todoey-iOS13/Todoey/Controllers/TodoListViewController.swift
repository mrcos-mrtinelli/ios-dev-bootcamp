//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addNewItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        addNewItemButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = addNewItemButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = selectedCategory?.name
        
        guard let navBar = navigationController?.navigationBar else { return }
        guard let navBarColor = UIColor(hexString: selectedCategory!.color) else { return }
        
        navBar.backgroundColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    //MARK: - TableView Datasource Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row], let color = UIColor(hexString: selectedCategory?.color ?? "0096FF") {
            cell.textLabel?.text = item.title
            cell.backgroundColor = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    @objc func addNewItem() {
        let ac = UIAlertController(title: "Add New To Do", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submit = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            if let input = ac?.textFields?.first?.text {
                guard let self = self else { return }
                
                
                if let category = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newToDo = Item()
                            
                            newToDo.title = input
                            category.items.append(newToDo)
                        }
                    } catch {
                        print("Error saving item: \(error)")
                    }
                }
                self.loadItems()

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
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch  {
                print("an error occurred when deleting: \(error)")
            }
        }
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "timestamp", ascending: false)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
