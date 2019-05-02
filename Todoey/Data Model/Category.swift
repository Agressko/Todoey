//
//  Category.swift
//  Todoey
//
//  Created by Andrey Chekmenev on 24/04/2019.
//  Copyright © 2019 Andrey Chekmenev. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
    
}

