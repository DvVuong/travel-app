//
//  DetailCountrysViewController.swift
//  Travel
//
//  Created by mr.root on 11/1/22.
//

import UIKit
import Combine

class DetailCountrysViewController: UIViewController {
    
    static func instance() -> DetailCountrysViewController {
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailCountrysViewController") as! DetailCountrysViewController
        return vc
    }
    @IBOutlet private weak var detailCountryTable: UITableView!
    var url: String = ""
    private let viewModel = DetailViewModel()
    private var subscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDetailCountry(url)
        updateUI()
        onBInd()
        
    }
    private func updateUI(){
        setupCountryTable()
    }
    private func onBInd(){
        viewModel.dosomething.sink(receiveValue: {self.detailCountryTable.reloadData()}).store(in: &subscriptions)
    }
    private func setupCountryTable(){
        detailCountryTable.delegate = self
        detailCountryTable.dataSource = self
    }
}
extension DetailCountrysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountry()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailCountryTable.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
        if let index = viewModel.cellForCountry(indexPath.row) {
            cell.updateUI(index)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return detailCountryTable.frame.height
    }
    
}
