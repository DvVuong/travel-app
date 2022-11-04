//
//  CollectionViewCell.swift
//  Travel
//
//  Created by mr.root on 11/3/22.
//

import UIKit
import FirebaseAuth

class CollectionViewCell: UICollectionViewCell {
    let id = Auth.auth().currentUser?.uid
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137, blue: 0, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textView: UILabel = {
            let tv = UILabel()
            tv.textColor = UIColor.white
            tv.font = UIFont.systemFont(ofSize: 16)
            tv.backgroundColor = UIColor.clear
            tv.numberOfLines = 0
            tv.translatesAutoresizingMaskIntoConstraints = false
            return tv
        }()
    let imgProfile: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = img.frame.height / 2
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
      var bubleWidthAnchor: NSLayoutConstraint?
      var bubleViewRightAnchor: NSLayoutConstraint?
      var bubleViewLeftAnchor: NSLayoutConstraint?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
       
    }
    func setupMessage(_ message: Massage) {
        ImageCache.share.fetchImage(message.avatarSender) { image in
            DispatchQueue.main.async {
                self.imgProfile.image = image
                self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
                self.imgProfile.layer.masksToBounds = true
            }
        }
        textView.text = message.massageSender
    }
    func setupTextView() {
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 8).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    func setupBubbleView() {
        addSubview(bubbleView)
        bubleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubleViewRightAnchor?.isActive = true
        
        bubleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: imgProfile.rightAnchor, constant: 8)
        bubleViewLeftAnchor?.isActive = false
        
        bubleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    func setupImageProfile() {
        addSubview(imgProfile)
        imgProfile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imgProfile.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

