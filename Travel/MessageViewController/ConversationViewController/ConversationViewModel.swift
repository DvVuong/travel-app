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
import FirebaseStorage
import UIKit
final class ConversationViewModel {
    let passImageStr = PassthroughSubject<String, Never>()
    let dosomething = PassthroughSubject<Void, Never>()
    let receiverIDPublisher = PassthroughSubject<String, Never>()
    var ref = Database.database().reference()
    var senderID: User?
    var otherUser: String = ""
    var receiverID: User?
    var message = [Message]()
    var imgMessage: String = ""
    var subcriptions = Set<AnyCancellable>()
    init() {
        passImageStr.sink { imgStr in
            self.imgMessage = imgStr
        }.store(in: &subcriptions)
        
        receiverIDPublisher.sink { idOther in
            self.otherUser = idOther
        }.store(in: &subcriptions)
    }
    func getCurrentUser() {
        if let id = Auth.auth().currentUser {
            self.ref.child("User").child(id.uid).observe(.value) { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let value = User(dict: dict)
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
                    if self.senderID?.id != result.id {
                        self.receiverID = result
                        self.dosomething.send(())
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
                    let value = Message(dict: dictionary)
                    if   self.otherUser == value.sendeID || self.otherUser == value.receiverID {
                        self.message.append(value)
                        self.dosomething.send(())
                    }
                }
            }
        }
    }
    func numberOfMessage() -> Int {
        return message.count
    }
    func cellForMessage(_ index: Int) -> Message? {
        guard index >= 0 && index < numberOfMessage() else  {
            return nil
        }
        return message[index]
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
            "massageSender": massage ,
            "time_send": currentTime,
            "imageMessage": imgMessage
        ]
       childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
           let userMassageRef = Database.database().reference().child("User-massage").child(self.senderID!.id )
            let value:  [String: Any] = ["\(childRef.key ?? "")": 1]
            userMassageRef.updateChildValues(value)
           let userReceiverIDMassageRef = Database.database().reference().child("User-massage").child(receiverID)
           let value1:  [String: Any] = ["\(childRef.key ?? "")": 1]
           userReceiverIDMassageRef.updateChildValues(value1)
        }
    }
    func uploadImageMessage(_ image: UIImage) {
        let imageName = NSUUID().uuidString
        let uploadDat = image.jpegData(compressionQuality: 0.4)!
        let storRef = Storage.storage().reference().child("imageMesseage").child(imageName)
        storRef.putData(uploadDat, metadata: nil) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                storRef.downloadURL { url, error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }else {
                        guard let url = url else { return }
                        self.imgMessage = "\(url)"
                        print("vuongdv",self.imgMessage)
                    }
                }
            }
        }
    }
    
}

