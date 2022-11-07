//
//  DetailCell.swift
//  Travel
//
//  Created by mr.root on 11/1/22.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet private weak var rating: UIStackView!
    @IBOutlet private weak var lbPoint: UILabel!
    @IBOutlet private weak var tvDescriptions: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
        img.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    func updateUI(_ data: DetailCountrys) {
        lbName.text = data.name
        tvDescriptions.text = data.descriptions
        lbPoint.text = "\(data.point_evaluation)"
        ImageCache.share.fetchImage(data.image) { image in
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
        for star in rating.arrangedSubviews {
            star.isHidden = star.tag > data.point_evaluation
        }
        
    }

}
