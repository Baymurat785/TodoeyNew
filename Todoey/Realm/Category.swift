//
//  Category.swift
//  Todoey
//
//  Created by Baymurat Abdumuratov on 11/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
   @objc dynamic var color = String()
    
    let items = List<Item>()  // Creating relationship with Item. List is from Realm
}
