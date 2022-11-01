//
//  CreateAccountViewController.swift
//  Travel
//
//  Created by mr.root on 10/19/22.
//

import UIKit
import Combine

class CreateAccountViewController: UIViewController {
    static func instance() -> CreateAccountViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccount") as! CreateAccountViewController
        return vc
    }
    
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var genderTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var userError: UILabel!
    @IBOutlet private weak var emailError: UILabel!
    @IBOutlet private weak var passwordError: UILabel!
    @IBOutlet private weak var btCreateAccount: UIButton!
    @IBOutlet private weak var phoneError: UILabel!
    @IBOutlet private weak var genderPicker: UIPickerView!
    @IBOutlet private weak var imgAvatar: UIImageView!
    var imgPicker = UIImagePickerController()
    
    
    var viewModel = CreateAccountViewModel()
    var subscriptions = Set<AnyCancellable>()
    var gender = ["Male","Female"]
    var selectedRow: Int {
        return genderPicker.selectedRow(inComponent: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        onBind()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    private func setupUI() {
        userTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //MARK:Lable
        userError.isHidden = true
        userError.textColor = .red
        emailError.isHidden = true
        emailError.textColor = .red
        passwordError.isHidden = true
        passwordError.textColor = .red
        phoneError.isHidden = true
        phoneError.textColor = .red
        phoneError.isHidden = true
        phoneError.textColor = .red
        //MARK: Button
        btCreateAccount.isEnabled = false
        //MARK: PickerView
        genderPicker.isHidden = true
        setupBtCreateAccount()
        setupTextField()
        setupGenderPicker()
        setupImageAvatar()
    }
    private func onBind() {
        viewModel.userErrorPublisher.assign(to: \.text, on: userError).store(in: &subscriptions)
        userError.isHidden = false
        viewModel.emailErrorPublisher.assign(to: \.text, on: emailError).store(in: &subscriptions)
        emailError.isHidden = false
        viewModel.passwordErrorPublisher.assign(to: \.text, on: passwordError).store(in: &subscriptions)
        passwordError.isHidden = false
        viewModel.phoneErrorPublisher.assign(to: \.text, on: phoneError).store(in: &subscriptions)
        passwordError.isHidden = false
        viewModel.phoneErrorPublisher.assign(to: \.text, on: phoneError).store(in: &subscriptions)
        phoneError.isHidden = false
        
            //MARK: Enable Button
        Publishers.CombineLatest4(viewModel.userErrorPublisher.map{$0 == nil},
                                  viewModel.emailErrorPublisher.map{$0 == nil},
                                  viewModel.phoneErrorPublisher.map{$0 == nil},
                                  viewModel.passwordErrorPublisher.map{$0 == nil}
        ).map{$0.0 && $0.1 && $0.2 && $0.3}.assign(to: \.isEnabled, on: btCreateAccount).store(in: &subscriptions)
    }
    private func setupBtCreateAccount(){
        btCreateAccount.layer.cornerRadius = 8
        btCreateAccount.layer.masksToBounds = true
        btCreateAccount.isEnabled = false
        //btCreateAccount.backgroundColor = UIColor.blue
        btCreateAccount.addTarget(self, action: #selector(didTapCreateAccount(_:)), for: .touchUpInside)
    }
    private func setupTextField(){
        userTextField.attributedPlaceholder = NSAttributedString(string: "Enter User", attributes: [.foregroundColor: UIColor.systemGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [.foregroundColor: UIColor.systemGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [.foregroundColor: UIColor.systemGray])
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Phone", attributes: [.foregroundColor: UIColor.systemGray])
        genderTextField.delegate = self
    }
    private func setupGenderPicker(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.isHidden = true
        genderPicker.layer.cornerRadius = 8
        genderPicker.layer.masksToBounds = true
    }
    
    private func setupImageAvatar(){
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.masksToBounds = true
        imgAvatar.contentMode = .scaleToFill
        imgAvatar.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapImageAvatar))
        imgAvatar.addGestureRecognizer(tapGes)
    }
    @objc func didTapImageAvatar(){
        let alert = UIAlertController(title: "Choose Image From?", message: nil, preferredStyle: .actionSheet)
        let imageFromLibrabri = UIAlertAction(title: "From librabri", style: .default) { action in
            self.imgPicker.delegate = self
            self.imgPicker.sourceType = .photoLibrary
            self.present(self.imgPicker, animated: true)
        }
        let imageCamera = UIAlertAction(title: "From Camera", style: .default) { action in
            self.imgPicker.delegate = self
            self.imgPicker.sourceType = .camera
            self.present(self.imgPicker, animated: true)
        }
        let cancel = UIAlertAction(title: "CanCel", style: .cancel, handler: nil)
        alert.addAction(imageFromLibrabri)
        alert.addAction(imageCamera)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    @objc private func textFieldDidChange(_ textField: UITextField){
        if textField === userTextField {
            viewModel.userPublisher.send(textField.text ?? "")
        }else if textField === emailTextField {
            viewModel.emailPublisher.send(textField.text ?? "")
        }else if textField === passwordTextField {
            viewModel.passwordPublisher.send(textField.text ?? "")
        }else if textField === phoneTextField {
            viewModel.phoneNumberPublsher.send(textField.text ?? "")
        }
    }
    @objc private func didTapCreateAccount(_ sender: Any){
        viewModel.createAccount(userTextField.text!, emailTextField.text!, phoneTextField.text!, passwordTextField.text!, genderTextField.text!, imgAvatar.image!) { (done) in
            if done {
                self.dismiss(animated: true)
            }else {
                print("Error")
            }
        }
        self.dismiss(animated: true)
     }
}
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == genderTextField {
            self.genderPicker.isHidden = false
        }
        return false
    }
}
extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       genderTextField.text = gender[row]
        self.genderPicker.isHidden = true
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var color = UIColor.gray
        if row == selectedRow {
            color = UIColor.white
        }else if selectedRow == row - 1 || selectedRow == row + 1 {
            color = UIColor.systemBlue
        }
        return NSAttributedString(string: gender[row], attributes: [.foregroundColor: color])
    }
}
extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgAvatar.image = image
        self.imgPicker.dismiss(animated: true)
    }
}
