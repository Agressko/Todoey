//
//  Item.swift
//  Todoey
//
//  Created by Andrey Chekmenev on 24/04/2019.
//  Copyright © 2019 Andrey Chekmenev. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
