//
//  ViewController.swift
//  Travel
//
//  Created by mr.root on 10/18/22.
//

import UIKit

class WellComeViewController: UIViewController {
   @IBOutlet private weak var lbTitel: UILabel!
   @IBOutlet private weak var lbTitel2: UILabel!
    @IBOutlet private weak var btGo: UIButton!
    @IBOutlet private weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLb()
        setupBtGo()
        setupTextView()
        
    }
    private func setupLb() {
        lbTitel.textColor = .white
        lbTitel.text = "Hi! Welcome to"
        lbTitel2.textColor = .white
        lbTitel2.text = "Travel Go "
        
    }
    private func setupBtGo(){
        btGo.setTitle("Let's GO", for: .normal)
        btGo.layer.cornerRadius = 8
        btGo.layer.masksToBounds = true
        btGo.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    private func setupTextView() {
       let attributedText = NSMutableAttributedString()
        let firtsAtt = NSAttributedString(string: "By creating an account or siging you agree to our Terms and Condititions!", attributes: [.foregroundColor: UIColor.white])
        attributedText.append(firtsAtt)
        let secondAtt = NSAttributedString(string: "Terms and Condititions", attributes: [.link: "https://www.google.com/?client=safari"])
        attributedText.append(secondAtt)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        attributedText.addAttribute(.paragraphStyle, value: style, range:NSMakeRange(0, attributedText.length))
        textView.attributedText = attributedText
        textView.linkTextAttributes = [
            .foregroundColor:UIColor.white,
            .underlineColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
            
        ]
        
        
    }
    @objc private func didTap() {
        let vc = LoginViewController.instance()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }


}

