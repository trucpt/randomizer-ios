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

extension MutableCollection {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}

extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}

extension String {
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var isValidPhoneNumber: Bool {
        let regex = "^((\\+)|(00)|(\\*)|())[0-9]{3,14}((\\#)|())$"
        let predi = NSPredicate(format: "SELF MATCHES %@", regex)
        return predi.evaluate(with: self) as Bool
    }
    
    var isValidVerificationCode: Bool {
        return (self.characters.count == 4)
    }
    
    var isValidPassword: Bool {
        return (self.characters.count == 6)
    }
    
    var halfwidth: String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformFullwidthHalfwidth, false)
        return mutableString as String
    }
    
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizeWithLang(_ lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        var bundle: Bundle?
        if path != nil {
            bundle = Bundle(path: path!)
        } else {
            bundle = Bundle.main
            print("Warning: No lproj for \(lang), system default set instead !")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    var description: String {
        return NSLocalizedString(self, tableName: "Descriptions", comment: "")
    }
    
    var imageName: String {
        return NSLocalizedString(self, tableName: "ImageName", comment: "")
    }
    
    var infoPlistString: String {
        return NSLocalizedString(self, tableName: "InfoPlist", comment: "")
    }
    
    func sizeOfTextInView(widthOfView: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: widthOfView, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedStringKey.font: font]
        return self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes, context: nil)
    }
    
    func replaceWithString(_ replacedString: String) -> String {
        if self.isEmpty {
            return ""
        }
        let objcString = self as NSString
        return objcString.replacingCharacters(in: NSMakeRange(0, replacedString.characters.count), with: replacedString)
    }
    
    subscript (i: Int) -> Character? {
        let count = self.characters.count
        if i < 0 || i >= count{
            return nil
        }else{
            return self[self.characters.index(self.startIndex, offsetBy: i)]
        }
    }
    
    subscript (i: Int) -> String {
        let character : Character? = self[i]
        if let ch = character{
            return String(ch)
        } else {
            return ""
        }
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        let count = self.characters.count
        let firstIndex : Int = r.lowerBound
        let secondIndex : Int = r.upperBound
        if (firstIndex < 0) || (secondIndex >= count) {
            return ""
        } else {
            return substring(with: Range(characters.index(startIndex, offsetBy: firstIndex) ..< characters.index(startIndex, offsetBy: secondIndex)))
        }
    }
    
    func optimalHeight(_ sizeWidth: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: sizeWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension UIView {
    
    func roundCorner() {
        roundCorner(UIColor.clear, borderWidth: 0.0)
    }
    
    func roundCorner(_ borderColor: UIColor, borderWidth: Float) {
        self.roundCorner(borderColor, borderWidth: borderWidth, cornerRadius: self.bounds.size.height / 2)
    }
    
    func roundCornerAndDropshadow(_ borderColor: UIColor, borderWidth: Float) {
        self.roundCornerAndDropshadow(borderColor, borderWidth: borderWidth, cornerRadius: self.bounds.size.height / 2)
    }
    
    func roundCornerAndDropshadow(_ borderColor: UIColor, borderWidth: Float, cornerRadius: CGFloat) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.borderColor = borderColor.cgColor
    }
    
    func roundCorner(_ borderColor: UIColor, borderWidth: Float, cornerRadius: CGFloat) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.borderWidth   = CGFloat(borderWidth)
        self.layer.borderColor   = borderColor.cgColor
        self.layer.masksToBounds = true
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func roundCornerForWrapperView(_ borderColor: UIColor) {
        self.roundCorner(borderColor, borderWidth: 1.0, cornerRadius: 5.0)
    }
    
    func roundCornerForPanel(_ borderColor: UIColor = UIColor.clear) {
        self.roundCorner(borderColor, borderWidth: 1.0, cornerRadius: 10.0)
    }
    
    func cardUi() {
        self.layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadowAtBottom() {
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadowAtTop() {
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 2.0, height: 0.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func cardBezzedUi() {
        self.layer.cornerRadius = 5.0
        self.layer.shadowOffset = CGSize(width: -0.7, height: 0.7)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func cardBezzedUi2() {
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: -0.7, height: 0.7)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func bottomBorderUi() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    
    
    func addMatchParentConstraintForSubview(_ subview: UIView) {
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    }
    
    func addGradientLayer() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [0xF9E0E0.toUIColor.cgColor, 0x9FB4CE.toUIColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.1, y: 0.1)
        gradient.endPoint = CGPoint(x: 0.9, y: 0.9)
        gradient.frame = self.bounds
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
