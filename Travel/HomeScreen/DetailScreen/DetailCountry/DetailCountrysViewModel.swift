//
//  DetailCountrysViewModel.swift
//  Travel
//
//  Created by mr.root on 11/4/22.
//

import Foundation
import Combine
import FirebaseDatabase
final class DetailCountrysViewModel {
    let passUrlPublisher = PassthroughSubject<String, Never>()
    let dosomething = PassthroughSubject<Void, Never>()
    var subscriptions = Set<AnyCancellable>()
    private let ref = Database.database().reference()
    var countrys = [DetailCountry]()
    private var url: String = ""
    init() {
        passUrlPublisher.sink { url in
            self.getCountrysForDatabase(url)
        }.store(in: &subscriptions)
    }
    
    private  func getCountrysForDatabase(_ url: String) {
        ref.child(url).observe(.childAdded) { (snapshot) in
            self.ref.child(url).child(snapshot.key).observe(.value) { (data) in
                if let dictionary = data.value as? [String: Any] {
                    let result = DetailCountry(dict: dictionary)
                    self.countrys.append(result)
                    self.dosomething.send(())
                }
            }
        }
    }
    func numberOfCountry() -> Int {
        return countrys.count
    }
    func cellOfCountry(_ index: Int) -> DetailCountry? {
        guard index >= 0 && index < numberOfCountry() else {
            return nil
        }
        return countrys[index]
    }
    
    
}
