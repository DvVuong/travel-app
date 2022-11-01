//
//  LoginViewModel.swift
//  Travel
//
//  Created by mr.root on 10/22/22.
//

import Foundation
import FirebaseAuth
final class LoginViewModel {
    
    
    func login(_ email: String, password: String, completion: (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
               
            }
        }
    }
}
