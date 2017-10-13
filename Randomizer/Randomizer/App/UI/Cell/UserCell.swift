//
//  UserCell.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    var onClickButton: ((_ user: User?)->Void)?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    var currentUser: User?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image.roundCorner(Const.colorGrey, borderWidth: 3)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapImageView))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapImageView() {
        onClickButton!(currentUser)
    }
    
    func customCell() {
        image.roundCorner(Const.colorRed, borderWidth: 3)
    }

    func updateUI(user: User?, selectedUsers: [User] ) {
        currentUser = user
        if selectedUsers.count == 0 {
            image.roundCorner(Const.colorGrey, borderWidth: 3)
        }
        for selectedUser in selectedUsers {
            if user!.id == selectedUser.id {
                image.roundCorner(Const.colorRed, borderWidth: 3)
                break
            } else {
                image.roundCorner(Const.colorGrey, borderWidth: 3)
            }
        }
        self.name.text = user?.name
        if (user?.imageUrl.isEmpty)! {
            self.image.image = UIImage(named: "image_user")
        } else {
            self.image.image = user!.image
        }
    }
}
