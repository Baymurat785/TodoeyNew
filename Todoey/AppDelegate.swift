//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let config = Realm.Configuration(
            schemaVersion: 2, // Increment this if you make changes to the schema
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Add the 'date' property to the Item object
                    migration.enumerateObjects(ofType: Item.className()) { oldObject, newObject in
                        newObject!["date"] = Date()
                    }
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config
        
        
        return true
    }
    
    
    

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
        
    }
 
    //MARK: CORE DATA
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    //MARK: -Core Data Saving Support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

