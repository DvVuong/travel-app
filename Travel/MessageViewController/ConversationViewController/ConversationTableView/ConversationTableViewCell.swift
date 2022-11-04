//
//  ConversationTableViewCell.swift
//  Travel
//
//  Created by mr.root on 10/26/22.
//

import UIKit
import FirebaseAuth

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var lbmassage: UILabel!
    var senderID = Auth.auth().currentUser?.uid
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateMassage(_ massage: Massage) {
        if massage.sendeID == senderID {
            lbmassage.backgroundColor = .blue
        }
        else {
            lbmassage.backgroundColor = .systemGray
        }
        lbmassage.text = massage.massageSender
    }

}
