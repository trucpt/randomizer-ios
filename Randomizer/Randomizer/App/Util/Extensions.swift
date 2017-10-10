//
//  Extensions.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import RealmSwift
extension Int {
    var toUIColor: UIColor {
        let r = (CGFloat)(((self & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat)(((self & 0x00FF00) >> 08)) / 255.0
        let b = (CGFloat)(((self & 0x0000FF) >> 00)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension Results {
    func toArray<T>(_ ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
