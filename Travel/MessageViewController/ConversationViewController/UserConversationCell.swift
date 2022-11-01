//
//  UserConversationCell.swift
//  Travel
//
//  Created by mr.root on 10/26/22.
//

import UIKit

class UserConversationCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    var url: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.layer.masksToBounds = true
        imgUser.contentMode = .scaleToFill
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(){
        ImageCache.share.fetchImage(url) { image in
            self.imgUser.image = image
        }
    }

}
