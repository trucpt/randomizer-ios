//
//  AddNewUserCell.swift
//  Randomizer
//
//  Created by nguyen ha on 10/11/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import UIKit

class AddNewUserCell: UICollectionViewCell {
    var onClickPlusButton: (()->Void)?
    
    @IBAction func onClickPlusButton(_ sender: Any) {
        onClickPlusButton!()
    }
    
}
