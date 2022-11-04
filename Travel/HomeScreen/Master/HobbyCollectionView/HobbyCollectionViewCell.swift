//
//  HobbyCollectionViewCell.swift
//  Travel
//
//  Created by mr.root on 10/31/22.
//

import UIKit

class HobbyCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var lnName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
    }
    func updateUI(_ hobby: Hobby){
        lnName.text = hobby.name
        ImageCache.share.fetchImage(hobby.image) { image in
            DispatchQueue.main.async {
                self.image.image = image
            }
            
        }
    }

}
