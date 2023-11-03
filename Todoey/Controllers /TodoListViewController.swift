//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

//"Find Mike", "Buy Eggos", "Destroy Demogorgon","Find Mike", "Buy Eggos", "Destroy Demogorgon","Find Mike"

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController, UISearchBarDelegate {
    
    let searchController = UISearchController()
    var todoItems: Results<Item>?
    let searchBar = UISearchBar()
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
        
        
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.separatorStyle = .none
                
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color { // the reason of getting this error "Navigation Controller Does not exist." is calling view did load before the navigation bar, so we will use viewDidAppear
            navigationItem.title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does not exist.")}
            
            if let navBarColor = UIColor(hexString: colorHex){
                navBar.backgroundColor = navBarColor
                    
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true) // this tintColor applies to all elements of the bar
                    searchBar.barTintColor = UIColor(hexString: colorHex)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)] // this code just changes the title of the bar.
            }
        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(todoItems!.count))){
                cell.backgroundColor = color //There will be a gradient of colors
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat:true)
            }
            
//            print("version 1: \(CGFloat(indexPath.row/todoItems!.count))")
//            print("version 2: \(CGFloat(indexPath.row)/CGFloat(todoItems!.count))")
            
            
            
            
            
            cell.accessoryType = item.done == false ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No items added"
        }
        
        
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        
   //     context.delete(itemArray[indexPath.row])
      //  itemArray.remove(at: indexPath.row)
            
//        
//        todoItems?[indexPath.row].done = !((todoItems?[indexPath.row].done) != nil)
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    //MARK: - Deletion Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)// you will get the things from the original updateModel which is in SwipeViewController, if you did not write this you will not get.
        
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }catch {
                print("Error deleting property, \(error)")
            }
        }
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // what will happen when user taps "Add Item" button
            
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = true
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new items, \(error)")
                }
            
            
            }
            
            
     
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   

    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)/*when you dismiss the search bar*/ {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    
    
    
    ////    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    ////        let request: NSFetchRequest<Item1> = Item1.fetchRequest()
    ////
    ////
    ////
    ////        print(searchBar.text!)
    ////
    ////    }
   
    //
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        if searchBar.text?.count == 0 {
    //            loadItems()
    //
    //            searchBar.resignFirstResponder()
    //
    //        }
    //    }
    //}
}
