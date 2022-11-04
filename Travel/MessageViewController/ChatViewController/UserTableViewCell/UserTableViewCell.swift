//
//  UserTableViewCell.swift
//  Travel
//
//  Created by mr.root on 10/23/22.
//

import UIKit
import Foundation


class UserTableViewCell: UITableViewCell {
    @IBOutlet private weak var imgUser: UIImageView!
    @IBOutlet  weak var lbName: UILabel!
    @IBOutlet private weak var lbMassage: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.layer.masksToBounds = true
        imgUser.layer.borderWidth = 1
        imgUser.contentMode = .scaleToFill
        imgUser.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ massage: Massage) {
        let timeSend = NSDate(timeIntervalSince1970: massage.time_send.doubleValue)
        let datmatter = DateFormatter()
        datmatter.timeZone = .current
        datmatter.locale = .current
        datmatter.dateFormat = "HH:mm"
        lbTime.text = datmatter.string(from: timeSend as Date)
        lbMassage.text = massage.massageSender
        ImageCache.share.fetchImage(massage.avatarSender) { image in
            self.imgUser.image = image
        }
    }

}
