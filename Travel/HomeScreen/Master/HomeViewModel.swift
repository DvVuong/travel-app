//
//  HomeViewModel.swift
//  Travel
//
//  Created by mr.root on 10/27/22.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase
import UIKit
final class  HomeViewModel {
    let userNamePublisher = CurrentValueSubject<String?, Never>(nil)
    let imgUserPublisher = PassthroughSubject<String, Never>()
    let dosomething = PassthroughSubject<Void, Never>()
    let searchHobby = PassthroughSubject<String, Never>()
    var users: User?
    var countrys = [Country]()
    var finalCountrys = [Country]()
    var hobbys = [Hobby]()
    var planes = [Universe]()
    let currentID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    var currentIndexCell = 0
    var subcriptions = Set<AnyCancellable>()
    @available(iOS 13.0, *)
    init(){
        searchHobby.sink { search in
            let upcaseSearch = search.uppercased().folding(options: .diacriticInsensitive, locale: nil)
            if search.isEmpty {
                self.finalCountrys = self.countrys
            } else {
                self.finalCountrys = self.countrys.filter{$0.name.folding(options: .diacriticInsensitive, locale: nil)
                                                .uppercased()
                                                .contains(upcaseSearch)
                    
                }
            }
            self.dosomething.send(())
        }.store(in: &subcriptions)
    }
    func getUser() {
        ref.child("User").observe(.childAdded) { (snapshot) in
            self.ref.child("User").child(snapshot.key).observe(.value) { (data) in
                if let dictionary = data.value as? [String: Any] {
                    let result = User(dict: dictionary)
                    if self.currentID == result.id {
                        self.users = result
                        self.users?.$userName.sink(receiveValue: { userName in
                            self.userNamePublisher.value = userName
                        }).store(in: &self.subcriptions)
                        self.users?.$Avatar.sink(receiveValue: { ulrAvartar in
                            self.imgUserPublisher.send(ulrAvartar)
                        }).store(in: &self.subcriptions)
                    }
                }
            }
        }
    }
    func getCountry() {
        ref.child("Country").observe(.childAdded) { (snapshot) in
            self.ref.child("Country").child(snapshot.key).observe(.value) { (dataSnapshot) in
                if let dictionary = dataSnapshot.value as? [String: Any] {
                   let result = Country(dict: dictionary)
                    self.countrys.append(result)
                    self.finalCountrys = self.countrys
                    self.dosomething.send(())
                }
            }
        }
    }
    func getHobby() {
        ref.child("Hobby").observe(.childAdded) { (snapshot) in
            self.ref.child("Hobby").child(snapshot.key).observe(.value) { (data) in
                if let dictionary = data.value as? [String: Any] {
                    let result = Hobby(dict: dictionary)
                    self.hobbys.append(result)
                    self.dosomething.send(())
                }
            }
        }
    }
    func getPlaneOfUniverse() {
        ref.child("The universe" ).observe(.childAdded) { (snapshot)  in
            self.ref.child("The universe").child(snapshot.key).observe(.value) { (data) in
                if let dictionary = data.value as? [String: Any] {
                    let result = Universe(dict: dictionary)
                    self.planes.append(result)
                    self.dosomething.send(())
                }
            }
        }
    }
    

    func numberOfsection() -> Int {
        return finalCountrys.count
    }
    func cellForCountry(_ index: Int) -> Country? {
        guard index >= 0 && index < numberOfsection() else  {
            return nil
        }
        return finalCountrys[index]
    }
    func numberOfHobby() -> Int {
        return hobbys.count
    }
    func cellForHobby(_ index: Int) -> Hobby? {
        guard index >= 0 && index < numberOfHobby() else {
            return nil
        }
        return hobbys[index]
    }
    func numberOfUniverse() -> Int {
        return planes.count
    }
    func cellForUniverse(_ index: Int) -> Universe? {
        guard index >= 0 && index < numberOfUniverse() else {
            return nil
        }
        return planes[index]
    }
    
    
    
}
