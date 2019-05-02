//
//  ViewController.swift
//  Todoey
//
//  Created by Andrey Chekmenev on 11/04/2019.
//  Copyright © 2019 Andrey Chekmenev. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?
    {
        didSet {
         loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//        print(dataFilePath)
        
//       loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //        cell.accessoryType = item.done ? .checkmark : .none
            
            if item.done == true {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
            
        }
        else {
            cell.textLabel?.text = "No items added"
        }
        
      
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch {
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        
//       todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
//        print(itemArray[indexPath.row].done)
        tableView.deselectRow(at: indexPath, animated: true)

//       saveItems()
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else
//        {
//            itemArray[indexPath.row].done = false
//        }
        
        
        
    }
    
//Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }
                catch {
                    print("Error saving new item, \(error)")
                }
            }
            self.tableView.reloadData()
       
//            self.saveItems()
      
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    

    
    func loadItems () {

       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()

}

}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
