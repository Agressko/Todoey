//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andrey Chekmenev on 22/04/2019.
//  Copyright © 2019 Andrey Chekmenev. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var katalogArray = [Katalog]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        
    }

 
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return katalogArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let katalog = katalogArray[indexPath.row]
        
        cell.textLabel?.text = katalog.name
        
        return cell
    }
    
   
    
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            let newKatalog = Katalog(context: self.context)
            newKatalog.name = textField.text!
            //    newKatalog.done = false
            self.katalogArray.append(newKatalog)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    
    
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
     //   tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = katalogArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulitaion Methods

    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    
    func loadItems (with request : NSFetchRequest<Katalog> = Katalog.fetchRequest()) {
        do {
            katalogArray = try context.fetch(request)
        }
        catch {
            print("Unable to read \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
