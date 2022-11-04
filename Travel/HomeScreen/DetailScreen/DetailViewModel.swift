//
//  DetailViewModel.swift
//  Travel
//
//  Created by mr.root on 11/1/22.
//

import Foundation
import FirebaseDatabase
import Combine
final class DetailViewModel {
    private var countrys = [Data]()
    private var ref = Database.database().reference()
    
    let dosomething = PassthroughSubject<Void, Never>()

    init(){}
    
    func getDetailCountry(_ url: String) {
        ref.child(url).observe(.childAdded) { (snapshot) in
            self.ref.child(url).child(snapshot.key).observe(.value) { (data) in
                if let dictionary = data.value as? [String: Any] {
                    let result = Data(dict: dictionary)
                    self.countrys.append(result)
                    self.dosomething.send(())
                }
            }
        }
    }
    func numberOfCountry() -> Int {
        return countrys.count
    }
    func cellForCountry(_ index: Int) -> Data? {
        guard index >= 0 && index < numberOfCountry() else {
            return nil
        }
        return countrys[index]
    }
}
