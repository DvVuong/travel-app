//
//  ConversationViewController.swift
//  Travel
//
//  Created by mr.root on 10/24/22.
//

import UIKit
import Combine
import FirebaseAuth

class ConversationViewController: UIViewController {
  public static func instance() -> ConversationViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConversationScreen") as! ConversationViewController
        return vc
    }
    @IBOutlet private weak var conversationCollection: UICollectionView!
    @IBOutlet private weak var masssageTextField: UITextField!
    @IBOutlet weak var massageWidthContrain: NSLayoutConstraint!
    
    @IBOutlet weak var massageHeightContrain: NSLayoutConstraint!
    
    @IBOutlet private var icon: UIImageView!

    var linkUrl: String = ""
    var lbName: String = ""
    var receiverID: String? = ""
    var reciverName: String = ""
    var viewModel = ConversationViewModel()
    var subcriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        onBind()
        viewModel.getMassageUser()
        viewModel.getAllUser()
        viewModel.getCurrentUser()
    
    }
    private func updateUI() {
       setupTableView()
        //MARK: MassageTextFIELD
        masssageTextField.layer.cornerRadius = 8
        masssageTextField.layer.masksToBounds = true
        masssageTextField.delegate = self
        setupIcon()
    }
    private func onBind() {
        viewModel.dosomething.sink(receiveValue: {self.conversationCollection.reloadData()}).store(in: &subcriptions)
        if let id = receiverID {
            viewModel.receiverIDPublisher.send(id)
        }
        
    }
    
    private func setupTableView() {
        conversationCollection.delegate = self
        conversationCollection.dataSource = self
        conversationCollection.alwaysBounceVertical = true
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        conversationCollection.register(nib, forCellWithReuseIdentifier: "chatCell")
        
        
        
    }
    private func setupIcon(){
        icon.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapOnSend))
        icon.addGestureRecognizer(tapGes)
        
    }

    @objc private func didTapOnSend() {
        if masssageTextField.text == "" {
            return
        }
        viewModel.inputMaaasge(masssageTextField.text!, reciverName, receiverID!, linkUrl)
        self.masssageTextField.text! = ""
    
    }
    
}
extension ConversationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = conversationCollection.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! CollectionViewCell
        if  let index = viewModel.userForCell(indexPath.item) {
            cell.setupMessage(index)
            cell.setupBubbleView()
            cell.setupTextView()
            cell.setupImageProfile()
            cell.bubleWidthAnchor?.constant = estiamtedFrameForMessage(index.massageSender).width + 32
            setupCell(cell, index)
        }
        return cell
    }
    private func setupCell(_ cell: CollectionViewCell, _ message: Massage ) {
        if message.sendeID == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 137, blue: 0, alpha: 1)
            cell.textView.textColor = .white
            cell.imgProfile.isHidden = true
            cell.bubleViewLeftAnchor?.isActive = false
            cell.bubleViewRightAnchor?.isActive = true
        } else {
            cell.bubbleView.backgroundColor = .systemGray
            cell.textView.textColor = UIColor.white
            cell.imgProfile.isHidden = false
            cell.bubleViewLeftAnchor?.isActive = true
            cell.bubleViewRightAnchor?.isActive = false
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 100
        if viewModel.massage[indexPath.item] != nil {
            height = estiamtedFrameForMessage(viewModel.massage[indexPath.item].massageSender).height + 10
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estiamtedFrameForMessage(_ message: String) -> CGRect {
        let size =  CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 10, right: 8)
    }
    
    
   
}
extension ConversationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.icon.image = UIImage(systemName: "paperplane.fill")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == masssageTextField {
            self.massageWidthContrain.constant = 250
           // self.icon.image = UIImage(named: "paperplane.fill")
            //self.icon.image = UIImage(systemName: "paperplane.fill")
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.massageWidthContrain.constant = 150
        self.icon.image = UIImage(systemName: "hand.thumbsup.fill")
    }
}
