//
//  ConversationTableViewCell.swift
//  Travel
//
//  Created by mr.root on 10/26/22.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var massage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
