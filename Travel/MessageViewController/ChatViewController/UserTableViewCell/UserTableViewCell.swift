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
    @IBOutlet private weak var imgMessage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.layer.masksToBounds = true
        imgUser.layer.borderWidth = 1
        imgUser.contentMode = .scaleToFill
        imgUser.layer.borderColor = UIColor.black.cgColor
        // MARK: ImgMessage
        imgMessage.isHidden = true
        imgMessage.contentMode = .scaleToFill
        imgMessage.layer.cornerRadius = 8
        imgMessage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ massage: Message) {
        guard let imgUrl = massage.imageMessage else  { return }
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
        guard let urlImage = massage.imageMessage else { return }
        if massage.massageSender.isEmpty {
            self.imgMessage.isHidden = false
            self.lbMassage.isHidden = true
            self.imgMessage.image = ImageCache.share.convertBase64ToImage(imgUrl)
//            ImageCache.share.fetchImage(urlImage) { image in
//                self.imgMessage.image = image
//            }
        } else {
            self.imgMessage.isHidden = true
        }
        
    }

}
