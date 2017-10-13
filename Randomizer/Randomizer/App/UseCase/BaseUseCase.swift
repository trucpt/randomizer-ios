//
//  BaseUseCase.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
class BaseUseCase: NSObject {
    
    class var currentTimeInSeconds: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    class var currentTimeMinutes: Int {
        return Int(Int(Date().timeIntervalSince1970) / 60)
    }
}
