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
    //@IBOutlet private weak var conversationCollection: UICollectionView!
    @IBOutlet private weak var conversationTableView: UITableView!
    @IBOutlet private weak var masssageTextField: UITextField!
    @IBOutlet weak var massageWidthContrain: NSLayoutConstraint!
    @IBOutlet weak var massageHeightContrain: NSLayoutConstraint!
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var camera: UIImageView!
    //@IBOutlet weak var sendImage: UIButton!
    //@IBOutlet weak var heightBtSendImageContrains: NSLayoutConstraint!
    
    
    
    
   
   
    let photoPickerView = UIImagePickerController()
    @IBOutlet private var icon: UIImageView!
   
    
    var linkUrl: String = ""
    var lbName: String = ""
    var receiverID: String? = ""
    var reciverName: String = ""
    var viewModel = ConversationViewModel()
    var subcriptions = Set<AnyCancellable>()
    var timer: Timer?
    private var imgStr: String = ""
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
       
    }
    private func onBind() {
        viewModel.dosomething.debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: {self.conversationTableView.reloadData()} ).store(in: &subcriptions)
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
//        sendImage.backgroundColor = .blue
//        sendImage.isHidden = true
//        sendImage.layer.cornerRadius = 8
//        sendImage.layer.masksToBounds = true
//        sendImage.addTarget(self, action: #selector(handleBtImage(_:)), for: .touchUpInside)
//        self.heightBtSendImageContrains.constant = 100
        
    }
    @objc fileprivate func handleBtImage(_ sender: UIButton) {
//        if sender === sendImage {
//            cancelImage.backgroundColor = .white
//        } else {
//            sendImage.backgroundColor = .white
//        }
    }
    fileprivate func setupTableView() {
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        conversationTableView.tableFooterView = UIView()
        conversationTableView.separatorStyle = .none
        conversationTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        
//        conversationCollection.delegate = self
//        conversationCollection.dataSource = self
//        conversationCollection.alwaysBounceVertical = true
//        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
//        conversationCollection.register(nib, forCellWithReuseIdentifier: "chatCell")
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
        self.imgStr = ""
        self.icon.image = UIImage(systemName: "hand.thumbsup.fill")
    
    }
}
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMessage()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.message[indexPath.item].sendeID == viewModel.senderID?.id {
            guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: "MessageForCurrentUser", for: indexPath) as? MessageForCurrentUserCell else {
                return UITableViewCell()
            }
            if let messagse = viewModel.cellForMessage(indexPath.item) {
                cell.updateUI(messagse)
               
            }
            return cell
        } else {
            guard let cell = conversationTableView.dequeueReusableCell(withIdentifier: "MessageForOtherUser", for: indexPath) as? MessageForOtherUserCell else  {
                return UITableViewCell()
            }
            if let message = viewModel.cellForMessage(indexPath.item)  {
                cell.updateUI(message)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.message[indexPath.item].massageSender.isEmpty{
            return 160
        } else {
            return UITableView.automaticDimension
        }
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
      
        guard let imageData = image else { return }
        self.imgStr = ImageCache.share.convertImgaeToBase64(image: imageData)
        viewModel.passImageStr.send(imgStr)
//        viewModel.uploadImageMessage(imageData)
//        self.heightBtSendImageContrains.constant = -100
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .transitionCrossDissolve, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
        viewModel.inputMaaasge(masssageTextField.text!, reciverName, receiverID!, linkUrl)
        photoPickerView.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        photoPickerView.dismiss(animated: true)
    }
    
}
