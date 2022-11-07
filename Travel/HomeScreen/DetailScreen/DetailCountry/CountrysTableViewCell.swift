//
//  CountrysTableViewCell.swift
//  Travel
//
//  Created by mr.root on 11/4/22.
//

import UIKit

class CountrysTableViewCell: UITableViewCell {
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet private weak var lbDescriptions: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        img.contentMode = .scaleToFill
    }
    func updateUI(_ data: DetailCountry) {
        lbName.text = data.name
        lbDescriptions.text = data.descriptions
        ImageCache.share.fetchImage(data.image) { image in
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
    }

}
