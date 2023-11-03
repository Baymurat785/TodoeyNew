//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Baymurat Abdumuratov on 27/09/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
//import SwipeCellKit


class CategoryViewController: SwipeTableViewController{
    
    lazy var realm : Realm = {
        return try! Realm()
    }()
  
    
    var categories: Results<Category>?
//    var delegate: SwipeTableViewCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadCategories()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Todoey"
        tableView.separatorColor = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }

    //MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
//    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)// when the cell of swipetableviewcontroller returns, it gets place into here
        
        if let category = categories?[indexPath.row] { 
            
            cell.textLabel?.text = category.name ?? "No Categories added yet"
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
       
        
        return cell
    }
   //MARK: Delete Data From Swipe
    
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)// you will get the things from the original updateModel which is in SwipeViewController, if you did not write this you will not get. 
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting property, \(error)")
            }
        }
    }
    
    
    
    //MARK: Data manupulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    
    
    
    //MARK: Add new categories
    

    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){
            (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue() // it saves a new color to the realm
            
         
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField {
            alertTextField in
            textField = alertTextField
            alertTextField.placeholder = "Create a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] 
        }
    }
    
}

    

