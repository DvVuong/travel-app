//
//  MessageForCurrentUserCell.swift
//  Travel
//
//  Created by mr.root on 11/8/22.
//

import UIKit

class MessageForCurrentUserCell: UITableViewCell {
    @IBOutlet private weak var imgMessage: UIImageView!
    var lbMessage: UILabel = {
       let lbMessage = UILabel()
        lbMessage.layer.cornerRadius = 5
        lbMessage.layer.masksToBounds = true
        lbMessage.numberOfLines = 0
        lbMessage.font = .systemFont(ofSize: 17)
        lbMessage.textColor = .white
        lbMessage.backgroundColor = UIColor(red: 0, green: 137, blue: 0, alpha: 1)
        lbMessage.translatesAutoresizingMaskIntoConstraints = false
        return lbMessage
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMessage.isUserInteractionEnabled = true
        
        imgMessage.layer.cornerRadius = 8
        imgMessage.layer.masksToBounds = true
        imgMessage.contentMode = .scaleToFill
        
        contentView.addSubview(lbMessage)
        lbMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        lbMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        lbMessage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -5).isActive = true
        lbMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func handdleZoomImage(tapGesture: UITapGestureRecognizer) {
        
    }
    func updateUI(_ message: Message) {
        guard let imgUrl = message.imageMessage else { return }
        lbMessage.text = message.massageSender
        
        if message.massageSender.isEmpty {
            lbMessage.isHidden = true
            self.imgMessage.isHidden = false
            self.imgMessage.image = ImageCache.share.convertBase64ToImage(imgUrl)
        }else {
            lbMessage.isHidden = false
            self.imgMessage.isHidden = true
        }
    }

}
