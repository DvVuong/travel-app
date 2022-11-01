//
//  LoginViewController.swift
//  Travel
//
//  Created by mr.root on 10/19/22.
//

import Foundation
import UIKit
import FirebaseAuth
import Toast_Swift
class LoginViewController: UIViewController {
    static func instance() -> LoginViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginScreen") as! LoginViewController
        return vc
    }
    @IBOutlet private weak var emailTextField:UITextField!
    @IBOutlet private weak var passwordTextField:UITextField!
    @IBOutlet private weak var btLogin: UIButton!
    @IBOutlet private weak var emailError: UILabel!
    @IBOutlet private weak var passwordError: UILabel!
    @IBOutlet private weak var viewEmail: UIView!
    @IBOutlet private weak var viewPassword: UIView!
    var viewModel = LoginViewModel()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewEmail()
        setupTextField()
        setupBt()
        setuplbError()
    }
    private func setupViewEmail() {
        viewEmail.layer.cornerRadius = 10
        viewEmail.layer.masksToBounds = true
        
        viewPassword.layer.cornerRadius = 10
        viewPassword.layer.masksToBounds = true
    }
    private func setupTextField(){
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [.foregroundColor: UIColor.white])
    }
    private func setupBt () {
        btLogin.layer.cornerRadius = 10
        btLogin.layer.masksToBounds = true
        btLogin.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    private func setuplbError(){
        emailError.isHidden = true
        passwordError.isHidden = true
    }
    @IBAction private func didTapCreateAccount(_ sender: Any) {
        let vc = CreateAccountViewController.instance()
        present(vc, animated: true)
    }
    @IBAction private func didTapForgetPassword(_ sender: Any) {
        
    }
    @objc private func didTapLogin(){
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {_, error in
            if error != nil {
                self.view.makeToast(error?.localizedDescription)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeScreen")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
}

