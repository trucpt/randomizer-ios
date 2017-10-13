//
//  DatabaseUserCase.swift
//  Randomizer
//
//  Created by nguyen ha on 10/11/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseUseCase: BaseUseCase {
    class func select<T: Object>(_ classType: T.Type) -> DatabaseQuery<T>? {
        return DatabaseSession.mainSession().queryForObjects(T.self)
    }
    
    class func getAllUser () -> [User] {
        if let data: [User] = select(User.self)?.results {
            return data
        }
        return []
    }
}
