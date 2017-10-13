//
//  UserUseCase.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
class UserUseCase: NSObject {
    func generateUser() {
        for i in 0...10 {
            let user = User()
            user.id = i
            _ = DatabaseSession.mainSession().writeObject(user)
        }
    }
    
}

class UserItem {
    enum ContentType {
        case user , addNewUserButton
    }
    var user: User?
    var contentType = ContentType.user
    
    init(user: User) {
        self.user = user
        self.contentType = ContentType.user
    }
    
    init(contentType: ContentType) {
        self.contentType = contentType
    }
}
