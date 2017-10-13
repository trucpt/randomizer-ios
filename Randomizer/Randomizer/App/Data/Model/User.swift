//
//  User.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var image: UIImage?
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
}

