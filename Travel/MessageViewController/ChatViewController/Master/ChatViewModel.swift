//
//  MessageViewModel.swift
//  Travel
//
//  Created by mr.root on 10/23/22.
//

import Foundation
import FirebaseAuth
import Combine
import FirebaseDatabase
final class ChatViewModel {
    var dosomething = PassthroughSubject<Void, Never>()
    var searchTextFieldPublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    var currentUser = [User]()
    var user: User?
    var otherUsers = [User]()
    var other: User?
    var massages = [Message]()
    var massageDictionary = [String: Message]()
    var finalMassge = [Message]()
    var ref = Database.database().reference()
    
    init() {
       
        searchTextFieldPublisher.sink { searchUser in
            let upcaseSearch = searchUser.folding(options: .diacriticInsensitive, locale: nil)
                                        .uppercased()
            if searchUser.isEmpty {
                self.finalMassge = self.massages
            }
            else {
                self.finalMassge = self.massages.filter{$0.nameSender
                                                        .folding(options: .diacriticInsensitive, locale: nil)
                                                        .uppercased()
                    .contains(upcaseSearch)}
            }
            self.dosomething.send(())
        }.store(in: &subscriptions)
        
    
    }
    
    func getcurrentUser() {
        if let id = Auth.auth().currentUser {
            ref.child("User").child(id.uid).observe(.value) { data in
                if let dict = data.value as? [String: Any] {
                    let result = User(dict: dict)
                    self.currentUser.append(result)
                    self.user = result
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
                            self.otherUsers.append(result)
                            self.other = result
                            self.dosomething.send(())
                       }
                    }
                }
            }

        }
    }
    func getMassage() {
        ref.child("Massage").observe(.childAdded) { snapshot in
            self.ref.child("Massage").child(snapshot.key).observe(.value) { dataSnapshot in
                if let value = dataSnapshot.value as? [String: Any] {
                    let result = Message(dict: value)
                    for i in self.currentUser {
                        if i.id == result.receiverID {
                            if let senderID = result.sendeID {
                                self.massageDictionary[senderID] = result
                                self.massages = Array(self.massageDictionary.values)
                                self.finalMassge = self.massages
                                self.dosomething.send(())
                            }
                        }
                    }
                }
            }
        }
    }
    func numberOfItem() -> Int {
        
        return otherUsers.count
    }
    func usersForCell(_ index: Int) -> User? {
       guard  index >= 0 && index < numberOfItem()  else {
            return nil
        }
        return otherUsers[index]
    }
    func numberOfItemTableView() -> Int {
        return finalMassge.count
    }
    func userForCellTableView(_ index: Int) -> Message? {
        guard index >= 0 && index < numberOfItemTableView() else {
            return nil
        }
        return finalMassge[index]
    }
}
