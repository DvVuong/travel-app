//
//  UniverseCell.swift
//  Travel
//
//  Created by mr.root on 10/31/22.
//

import UIKit

class UniverseCell: UICollectionViewCell {
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var lbName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
    }
    func updateUI(_ univer: Universe) {
        lbName.text = univer.name
        ImageCache.share.fetchImage(univer.image) { image in
            self.image.image = image
        }
    }

}
