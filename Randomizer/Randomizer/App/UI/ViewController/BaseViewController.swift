//
//  BaseViewController.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.colorGrey100
        if let _ = self.navigationController?.interactivePopGestureRecognizer {
            self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        }
    }
}
