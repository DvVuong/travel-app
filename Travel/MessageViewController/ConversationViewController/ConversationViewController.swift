//
//  ConversationViewController.swift
//  Travel
//
//  Created by mr.root on 10/24/22.
//

import UIKit
import Combine
import PhotosUI
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
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var camera: UIImageView!
    @IBOutlet private weak var sendImage: UIButton!
    @IBOutlet private weak var cancelImage: UIButton!
    @IBOutlet private weak var viewBtSendImage: UIView!
    let photoPickerView = UIImagePickerController()
    @IBOutlet private var icon: UIImageView!
    @IBOutlet weak var heightViewSendImageContrains: NSLayoutConstraint!
    
    var linkUrl: String = ""
    var lbName: String = ""
    var receiverID: String? = ""
    var reciverName: String = ""
    var viewModel = ConversationViewModel()
    var subcriptions = Set<AnyCancellable>()
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        onBind()
        viewModel.getMassageUser()
        viewModel.getAllUser()
        viewModel.getCurrentUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLayoutSubviews() {
        viewBtSendImage.addSubview(sendImage)
        viewBtSendImage.addSubview(cancelImage)
    }
    private func updateUI() {
       setupTableView()
        //MARK: MassageTextFIELD
        masssageTextField.layer.cornerRadius = 12
        masssageTextField.layer.masksToBounds = true
        masssageTextField.delegate = self
        masssageTextField.addTarget(self, action: #selector(handelIcon(_:)), for: .editingChanged)
        setupIcon()
        setupCameraAndPhoto()
        setupBtSendImage()
        self.heightViewSendImageContrains.constant = -50
    }
    private func onBind() {
        viewModel.dosomething.sink(receiveValue: {self.conversationCollection.reloadData()}).store(in: &subcriptions)
        if let id = receiverID {
            viewModel.receiverIDPublisher.send(id)
        }
    }
    @objc fileprivate func handelIcon(_ textField: UITextField) {
        if textField == masssageTextField {
            if textField.text!.isEmpty {
                self.icon.image = UIImage(systemName: "hand.thumbsup.fill")
            }
            else {
                self.icon.image = UIImage(systemName: "paperplane.fill")
            }
        }
    }
    fileprivate func setupBtSendImage() {
        viewBtSendImage.addSubview(sendImage)
        sendImage.backgroundColor = .blue
        sendImage.isHidden = true
        sendImage.layer.cornerRadius = 8
        sendImage.layer.masksToBounds = true
        sendImage.addTarget(self, action: #selector(handleBtImage(_:)), for: .touchUpInside)
        //
        viewBtSendImage.addSubview(cancelImage)
        cancelImage.backgroundColor = .blue
        cancelImage.isHidden = true
        cancelImage.layer.cornerRadius = 8
        cancelImage.layer.masksToBounds = true
        cancelImage.addTarget(self, action: #selector(handleBtImage(_:)), for: .touchUpInside)
    }
    @objc fileprivate func handleBtImage(_ sender: UIButton) {
//        if sender === sendImage {
//            cancelImage.backgroundColor = .white
//        } else {
//            sendImage.backgroundColor = .white
//        }
    }
    fileprivate func setupTableView() {
        conversationCollection.delegate = self
        conversationCollection.dataSource = self
        conversationCollection.alwaysBounceVertical = true
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        conversationCollection.register(nib, forCellWithReuseIdentifier: "chatCell")
    }
    fileprivate func setupIcon(){
        icon.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapOnSend))
        icon.addGestureRecognizer(tapGes)
    }
    fileprivate func setupCameraAndPhoto() {
        camera.isUserInteractionEnabled = true
        let tapGesCamera = UITapGestureRecognizer(target: self, action: #selector(didTapTakePhotoFormCamera))
        camera.addGestureRecognizer(tapGesCamera)
        
        photo.isUserInteractionEnabled = true
        let tapGesPhoto = UITapGestureRecognizer(target: self, action: #selector(didTapChoosePhoto))
        photo.addGestureRecognizer(tapGesPhoto)
    }
    @objc func didTapTakePhotoFormCamera() {
        
        
        
    }
    @objc func didTapChoosePhoto() {
        photoPickerView.delegate = self
        
        present(photoPickerView, animated: true, completion: nil)
    }
    @objc private func didTapOnSend() {
        if masssageTextField.text == "" {
            return
        }
        viewModel.inputMaaasge(masssageTextField.text!, reciverName, receiverID!, linkUrl)
        self.masssageTextField.text! = ""
        self.icon.image = UIImage(systemName: "hand.thumbsup.fill")
    
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
    private func setupCell(_ cell: CollectionViewCell, _ message: Message ) {
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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        conversationCollection.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        height = estiamtedFrameForMessage(viewModel.message[indexPath.item].massageSender).height + 20
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
        if textField == masssageTextField {
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == masssageTextField {
            self.massageWidthContrain.constant = 250
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.massageWidthContrain.constant = 150
        self.icon.image = UIImage(systemName: "hand.thumbsup.fill")
    }
}

extension ConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imgStr = ImageCache.share.convertImgaeToBase64(image: image!)
        viewModel.passImageStr.send(imgStr)
        self.heightViewSendImageContrains.constant = 100
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .transitionCrossDissolve, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        photoPickerView.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        photoPickerView.dismiss(animated: true)
    }
    
}
