//
//  CacheManager.swift
//  Randomizer
//
//  Created by nguyen ha on 10/11/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import SDWebImage

class CacheManager: BaseUseCase {
    static let imageKeyPrefix: String = "cache-randomizer"
    static func cacheImage(_ image: UIImage!, imageId: String!) {
        SDImageCache.shared().store(image, forKey: self.imageKeyPrefix + imageId)
    }
    
    static func getCachedImage(imageId: String) -> UIImage? {
        if let imageCache: UIImage = SDImageCache.shared().imageFromDiskCache(forKey: self.imageKeyPrefix + imageId) {
            return imageCache
        }
        return nil
    }
    
    static func removeCachedImage(imageId: String) {
        SDImageCache.shared().removeImage(forKey: self.imageKeyPrefix + imageId, fromDisk: true)
    }
    
    class func generateImageId(user: User?) -> String? {
        if user != nil {
            return "\(user!.id)" + "\(user!.name)"
        }
        return ""
    }
    
}
