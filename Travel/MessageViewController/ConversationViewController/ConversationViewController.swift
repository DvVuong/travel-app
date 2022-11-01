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
    @IBOutlet private weak var conversationTable: UITableView!
    @IBOutlet private weak var masssageTextField: UITextField!
    @IBOutlet weak var massageWidthContrain: NSLayoutConstraint!
    
    @IBOutlet weak var massageHeightContrain: NSLayoutConstraint!
    
    @IBOutlet private var icon: UIImageView!

    
    
    
    var linkUrl: String = ""
    var lbName: String = ""
    var receiverID: String = ""
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
        viewModel.getMassage()
    
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
        viewModel.dosomething.sink(receiveValue: {self.conversationTable.reloadData()}).store(in: &subcriptions)
    
    }
    
    private func setupTableView() {
        conversationTable.delegate = self
        conversationTable.dataSource = self
        conversationTable.tableFooterView = UIView()
        conversationTable.separatorStyle = .none
        let nib = UINib(nibName: "CustomHeaderCell", bundle: nil)
        conversationTable.register(nib, forCellReuseIdentifier: "customHeaderCell")
        
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
        viewModel.inputMaaasge(masssageTextField.text!, reciverName, receiverID, linkUrl)
        self.masssageTextField.text! = ""
    
    }
    
}
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = conversationTable.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserConversationCell
        if  let index = viewModel.userForCell(indexPath.row) {
//            cell.lbName.text = index.nameReceiver
//            cell.url = index.avatarReceiver
//            cell.backgroundColor = .blue
            cell.textLabel?.text = index.massage
            cell.updateUI()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
        let heagerCell = tableView.dequeueReusableCell(withIdentifier: "customHeaderCell") as! CustomHeaderCell
        heagerCell.lbUserName = lbName
        heagerCell.urlAvatar = linkUrl
        heagerCell.updateUI()
//        headerView.addSubview(heagerCell)
        return heagerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
   
}
extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == masssageTextField {
            self.massageWidthContrain.constant = 250
           // self.icon.image = UIImage(named: "paperplane.fill")
            self.icon.image = UIImage(systemName: "paperplane.fill")
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.massageWidthContrain.constant = 150
        self.icon.image = UIImage(systemName: "hand.thumbsup.fill")
    }
}
