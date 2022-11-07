//
//  MessageViewController.swift
//  Travel
//
//  Created by mr.root on 10/23/22.
//

import UIKit
import Combine

class ChatViewController: UIViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet private weak var viewSearch: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet weak var listUserCollection: UICollectionView!
    @IBOutlet private weak var userTableView: UITableView!
    @IBOutlet weak var heightContrainCollectionView: NSLayoutConstraint!
    @IBOutlet private weak var lbSuggestions: UILabel!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var viewTitle: UIView!
    @IBOutlet private weak var viewTitleHeightContrains: NSLayoutConstraint!
    @IBOutlet weak var topSearchViewContrains: NSLayoutConstraint!
    
    
    private var viewModel = ChatViewModel()
    private var cellModel = TableViewModel()
    private var subscriptions = Set<AnyCancellable>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getcurrentUser()
        viewModel.getAllUser()
        viewModel.getMassage()
        setupUI()
        onBind()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let indexPath = userTableView.indexPathForSelectedRow {
            userTableView.deselectRow(at: indexPath, animated: true)
        }
    }
       
    private func setupUI() {
        lbTitle.layer.borderWidth = 0
        viewSearch.layer.cornerRadius = 8
        viewSearch.layer.masksToBounds = true
        setupListUserCollection()
        setupTableView()
        setupLbSuggestions()
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextFieldidChange(_:)), for: .editingChanged)
    }
    private func onBind(){
        viewModel.dosomething.sink(receiveValue: {self.listUserCollection.reloadData()}).store(in: &subscriptions)
        viewModel.dosomething.sink(receiveValue: {self.userTableView.reloadData()}).store(in: &subscriptions)
        
        
    }
    private func setupTableView() {
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tableFooterView = UIView()
        userTableView.separatorStyle = .none
    }
    private func setupLbSuggestions() {
        lbSuggestions.text = "Gợi ý"
        lbSuggestions.isHidden = true
        
    }
    private func setupListUserCollection(){
        listUserCollection.delegate = self
        listUserCollection.dataSource = self
        
        let nib = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        listUserCollection.register(nib, forCellWithReuseIdentifier: "userCollectionCell")
        if let layout = listUserCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
        }
    }
    @objc private func searchTextFieldidChange(_ textField: UITextField) {
        if textField === self.searchTextField {
            viewModel.searchTextFieldPublisher.send(textField.text ?? "")
        }
    }
}
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItem()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = listUserCollection.dequeueReusableCell(withReuseIdentifier: "userCollectionCell", for: indexPath) as! UsersCollectionViewCell
        if let index = viewModel.usersForCell(indexPath.item) {
            cell.updateUI(index)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ConversationViewController.instance()
        if let index = viewModel.usersForCell(indexPath.item) {
            vc.title = index.userName
            vc.lbName = index.userName
            vc.linkUrl = index.Avatar
            vc.receiverID = index.id
            vc.reciverName = index.userName
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        userTableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.heightContrainCollectionView.constant = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .transitionCrossDissolve, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.topSearchViewContrains.constant = 0
        UIView.transition(with: self.viewTitle, duration: 0.5, options: .transitionCrossDissolve
                          , animations: {
            self.viewTitle.isHidden = true
        }, completion: nil)
        self.viewTitle.isHidden = true
        self.lbSuggestions.isHidden = false
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.heightContrainCollectionView.constant = 100
        UIView.transition(with: self.listUserCollection , duration: 0.5, options: .transitionCrossDissolve) {
            self.listUserCollection.isHidden = false
        }
        self.topSearchViewContrains.constant = 50
        UIView.transition(with: self.viewTitle, duration: 0.5, options: .transitionCrossDissolve
                          , animations: {
            self.viewTitle.isHidden = false
        }, completion: nil)
        self.lbSuggestions.isHidden = true
    }
    
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemTableView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as! UserTableViewCell
        if let index = viewModel.userForCellTableView(indexPath.item) {
            cell.updateUI(index)
            cell.lbName.attributedText = cellModel.setHiglight(searchTextField.text!, index.nameSender)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationViewController.instance()
        if let index = viewModel.userForCellTableView(indexPath.row) {
            vc.title = index.nameSender
            vc.lbName = index.nameSender
            vc.linkUrl = index.avatarSender
            vc.receiverID = index.sendeID!
            vc.reciverName = index.nameSender
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
