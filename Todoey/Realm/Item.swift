//
//  Item.swift
//  Todoey
//
//  Created by Baymurat Abdumuratov on 11/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?

    var paretnCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    //Remember when creating objects using Realm, we have to add @objc modifier and also dynamic keyword
}
