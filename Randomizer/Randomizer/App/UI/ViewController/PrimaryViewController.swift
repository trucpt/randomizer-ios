//
//  PrimaryViewController.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import UIKit

class PrimaryViewController: BaseViewController {
    // MARK:- UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.navigationController?.navigationBar.barStyle            = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Const.colorBlack]
        self.navigationController?.navigationBar.tintColor           = Const.colorWhite
        self.navigationController?.navigationBar.barTintColor        = Const.colorWhite
        self.navigationController?.navigationBar.isOpaque = false
    }
    
    // MARK:- Setup UI
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
