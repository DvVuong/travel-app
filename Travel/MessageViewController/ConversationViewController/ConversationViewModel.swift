//
//  ConversationViewModel.swift
//  Travel
//
//  Created by mr.root on 10/24/22.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase
final class ConversationViewModel {
    let dosomething = PassthroughSubject<Void, Never>()
    var ref = Database.database().reference()
    var currentUser = [User]()
    var senderID: User?
    var otherUser = [User]()
    var receiverID: User?
    var massage = [Massage]()
    var massage2: Massage?
    init(){}
    
    func getCurrentUser() {
        if let id = Auth.auth().currentUser {
            self.ref.child("User").child(id.uid).observe(.value) { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let value = User(dict: dict)
                    self.currentUser.append(value)
                    self.senderID = value
                    self.dosomething.send(())
                }
            }
        }
    }
    func getAllUser() {
        ref.child("User").observe(.childAdded) { snapshot in
            self.ref.child("User").child(snapshot.key).observe(.value) { data in
                if let value = data.value as? [String: Any] {
                    let result = User(dict: value)
                    for i in self.currentUser {
                        if i.id != result.id {
                            self.otherUser.append(result)
                            self.receiverID = result
                            self.dosomething.send(())
                        }
                    }
                }
            }

        }
    }
    
    //MARK: GET ALLMASSAGE FOR PER USER
    func getMassageUser() {
        let uid = Auth.auth().currentUser?.uid
        let userMassgerRef = Database.database().reference().child("User-massage").child(uid!)
        userMassgerRef.observe(.childAdded) { (snapshot) in
            let massageID = snapshot.key
            let massageReference = Database.database().reference().child("Massage").child(massageID)
            massageReference.observe(.value) { (data) in
                if let dictionary = data.value as? [String: Any] {
                    let value = Massage(dict: dictionary)
                    for i in self.currentUser {
                        if i.id  == value.receiverID {
                            self.massage.append(value)
                            self.dosomething.send(())
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: GET MASSAGE
    func getMassage() {
//        ref.child("Massage").observe(.childAdded) { snapshot in
//            self.ref.child("Massage").child(snapshot.key).observe(.value) { dataSnapshot in
//                if let value = dataSnapshot.value as? [String: Any] {
//                    let result = Massage(dict: value)
//                    for i in self.currentUser {
//                        if i.id == result.receiverID {
//                            self.massage.append(result)
//                            self.dosomething.send(())
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func numberOfItem() -> Int {
        return massage.count
    }
    func userForCell(_ index: Int) -> Massage? {
        guard index >= 0 && index < numberOfItem() else  {
            return nil
        }
        return massage[index]
    }
    
    func inputMaaasge(_ massage: String, _ reciverName: String, _ receiverID: String, _ linkAvatar: String) {
        let ref = Database.database().reference().child("Massage")
        let childRef = ref.childByAutoId()
        let currentTime = Date().timeIntervalSince1970
       
        let value: [String: Any] = [
            "sendeID": senderID!.id,
            "avatarSender": senderID!.Avatar,
            "receiverID":  receiverID,
            "nameSender": senderID!.userName,
            "nameReceiver":  reciverName,
            "avatarReceiver": linkAvatar,
            "massage": massage ,
            "time_send": currentTime
        ]
       childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let userMassageRef = Database.database().reference().child("User-massage").child(self.senderID!.id)
            let value:  [String: Any] = ["\(childRef.key ?? "")": 1]
            userMassageRef.updateChildValues(value)
        }
    }
    
}

