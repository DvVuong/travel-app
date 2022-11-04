//
//  Massage.swift
//  Travel
//
//  Created by mr.root on 10/25/22.
//

import Foundation
import FirebaseAuth
struct Massage {
    let sendeID: String?
    let receiverID: String?
    let nameSender: String
    let nameReceiver: String
    let avatarReceiver: String
    let massageSender: String
    let time_send: NSNumber
    let avatarSender: String
    init(dict: [String: Any]) {
        self.sendeID = dict["sendeID"] as? String ?? ""
        self.receiverID = dict["receiverID"] as? String ?? ""
        self.nameSender = dict["nameSender"] as? String ?? ""
        self.nameReceiver = dict["nameReceiver"] as? String ?? ""
        self.massageSender = dict["massageSender"] as? String ?? ""
        self.time_send = dict["time_send"] as? NSNumber ?? 0.0
        self.avatarReceiver = dict["avatarReceiver"] as? String ?? ""
        self.avatarSender = dict["avatarSender"] as? String ?? ""
        
    }
    func chatPartnerID() -> String? {
        let id = Auth.auth().currentUser?.uid
        print("vuongdv",id)
        return receiverID == Auth.auth().currentUser?.uid ? sendeID : receiverID
    }
}
