//
//  UsersCollectionViewCell.swift
//  Travel
//
//  Created by mr.root on 10/23/22.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbNameUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.layer.masksToBounds = true
        imgUser.contentMode = .scaleToFill
        imgUser.layer.borderWidth = 1
        imgUser.layer.borderColor = UIColor.black.cgColor
    }
    func updateUI(_ users: User) {
        lbNameUser.text = users.userName
        ImageCache.share.fetchImage(users.Avatar) { image in
            DispatchQueue.main.async {
                self.imgUser.image = image
            }
        }
    }

}
