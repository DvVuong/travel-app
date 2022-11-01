//
//  CreateAccountViewModel.swift
//  Travel
//
//  Created by mr.root on 10/19/22.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit
import Toast_Swift

final class CreateAccountViewModel {
    let userErrorPublisher = CurrentValueSubject<String?, Never>("")
    let emailErrorPublisher = CurrentValueSubject<String?, Never>("")
    let passwordErrorPublisher = CurrentValueSubject<String?, Never>("")
    let phoneErrorPublisher = CurrentValueSubject<String?, Never>("")
    
    
    let userPublisher = PassthroughSubject<String, Never>()
    let emailPublisher = PassthroughSubject<String, Never>()
    let passwordPublisher = PassthroughSubject<String, Never>()
    let phoneNumberPublsher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    typealias Complete = (StateCreate) -> Void
    var databaseReference = Database.database().reference()
    
    
    init() {
        //Subscrip
        userPublisher.map{self.validaUser($0)}.sink { valiPari in
            self.userErrorPublisher.value = valiPari.1
        }.store(in: &subscriptions)
        emailPublisher.map{self.validEmail($0)}.sink { valiPari in
            self.emailErrorPublisher.value = valiPari.1
        }.store(in: &subscriptions)
        passwordPublisher.map{self.validPassword($0)}.sink { valiPari in
            self.passwordErrorPublisher.value = valiPari.1
        }.store(in: &subscriptions)
        phoneNumberPublsher.map {self.validPhone($0)}.sink { valiPari in
            self.phoneErrorPublisher.value = valiPari.1
        }.store(in: &subscriptions)
        
        phoneNumberPublsher.sink { phone in
            print(phone)
        }.store(in: &subscriptions)
    }
    enum StateCreate {
        case succsess
        case faiulre
    }
    
    private func validaUser(_ user: String) -> (Bool, String?) {
        if user.isEmpty {
            return (false, "User Can't Emty")
        }
        return (true, nil)
    }
    
    private func validEmail(_ email: String)  -> (Bool, String?) {
        if email.isEmpty {
            return (false, "Email can't Emty")
        }
        if !isValidEmail(email){
            return (false, "Email invalidate")
        }
        return (true, nil)
    }
    
    private func validPhone(_ phone: String) -> (Bool, String?) {
        if phone.isEmpty {
            return (false, "PhoneNumber can't Emty")
        }
        return (true, nil)
    }
   private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    private func isValidPhone(_ phone: String)  -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phonePred.evaluate(with: phone)
    }
    private func validPassword(_ password: String) -> (Bool, String?) {
        if password.isEmpty {
            return (false, nil)
        }
//        if password.count < 8 {
//            return (false, "password should not be less than 8")
//        }
        return (true, nil)
    }
    func createAccount(_ user: String, _ email: String, _ phone: String, _ password: String,_ gender: String, _ avatar: UIImage?, _ complete: (Bool) -> Void) {
            if avatar == nil {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }else{
                    if let data = result {
                        let idUser = data.user.uid
                        let id = data.user.uid
                        let value = ["nameUser": user, "email": email, "phone": phone, "Gender": gender, "id": id]
                        self.databaseReference.child("User").child(idUser).setValue(value)
                    }
                }
            }
            }else{
                if  avatar != nil {
                    if let img = avatar!.jpegData(compressionQuality: 0.4) {
                        let key = self.databaseReference.childByAutoId().key!
                        let dataStorageReferenc = Storage.storage().reference()
                        let imgfolder = dataStorageReferenc.child("Avatar").child(key)
                        imgfolder.putData(img, metadata: nil) { result, error in
                            if error != nil {
                                print("error")
                            } else {
                                imgfolder.downloadURL { avatarUrl, error in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    }else {
                                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                                            if error != nil {
                                                print(error!.localizedDescription)
                                            } else {
                                                if let data = result {
                                                    guard let url = avatarUrl else { return }
                                                    let idUser = data.user.uid
                                                    let id = data.user.uid
                                                    let value = ["userName": user,
                                                                 "email": email,
                                                                 "gender": gender,
                                                                 "phone": phone,
                                                                 "Avatar": "\(url)",
                                                                 "id": id
                                                    ]
                                                    self.databaseReference.child("User").child(idUser).setValue(value)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }

    


