//
//  ResourceProvider.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import UIKit

class ResourceProvider {
    
    class func getViewController<T: UIViewController>(_ classType: T.Type ) -> T {
        return classType.init(nibName:String(describing: classType).components(separatedBy: ".").last!, bundle:nil)
    }
    
}
