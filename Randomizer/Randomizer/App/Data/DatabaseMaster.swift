//
//  DatabaseMaster.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import RealmSwift
class DatabaseMaster {
    
    static let sharedInstance = DatabaseMaster()
    
    static let databaseVersion: UInt64 = 201710101300
    
    static let deleteDatabaseIfMigrationNeeded = false
    static let mainDatabaseSession = DatabaseSession()
    
    func create() {
        // Realm schema version
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = DatabaseMaster.databaseVersion
        config.migrationBlock = { (migration, oldSchemaVersion) in
        }
        config.deleteRealmIfMigrationNeeded = DatabaseMaster.deleteDatabaseIfMigrationNeeded
        Realm.Configuration.defaultConfiguration = config
        DatabaseMaster.mainDatabaseSession.openSession()
    }
    
}
