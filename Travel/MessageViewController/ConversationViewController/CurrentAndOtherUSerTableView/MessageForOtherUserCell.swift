//
//  MessageForOtherUserCell.swift
//  Travel
//
//  Created by mr.root on 11/8/22.
//

import UIKit

class MessageForOtherUserCell: UITableViewCell {
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var imgMessage: UIImageView!
    var lbMessage: UILabel = {
       let lbMessage = UILabel()
        lbMessage.layer.cornerRadius = 8
        lbMessage.layer.masksToBounds = true
        lbMessage.numberOfLines = 0
        lbMessage.font = .systemFont(ofSize: 20)
        lbMessage.textColor = .white
        lbMessage.backgroundColor = UIColor(red: 0, green: 137, blue: 0, alpha: 1)
        lbMessage.translatesAutoresizingMaskIntoConstraints = false
        return lbMessage
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbMessage.numberOfLines = 0
        
        imgProfile.contentMode = .scaleToFill
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        imgProfile.layer.masksToBounds = true
        
        imgMessage.contentMode = .scaleToFill
        imgMessage.layer.cornerRadius = 8
        imgMessage.layer.masksToBounds = true
        imgMessage.isHidden = true
        
        lbMessage.layer.cornerRadius = 5
        lbMessage.layer.masksToBounds = true
        
        lbMessage.backgroundColor = .systemGray
        lbMessage.textColor = .white
        contentView.addSubview(lbMessage)
        lbMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
        lbMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        lbMessage.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        lbMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        lbMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ message: Message) {
        guard let imgUrl = message.imageMessage else { return }
        self.lbMessage.text = message.massageSender
        ImageCache.share.fetchImage(message.avatarSender) { image in
            DispatchQueue.main.async {
                self.imgProfile.image = image
            }
        }
        if message.massageSender.isEmpty {
            self.lbMessage.isHidden = true
            self.imgMessage.isHidden = false
            self.imgMessage.image = ImageCache.share.convertBase64ToImage(imgUrl)
        }else {
            self.lbMessage.isHidden = false
            self.imgMessage.isHidden = true
        }
    }

}
