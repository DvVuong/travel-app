//
//  DetailCountrysViewController.swift
//  Travel
//
//  Created by mr.root on 11/4/22.
//

import UIKit
import Combine

class DetailCountrysViewController: UIViewController {
    static func instance() -> DetailCountrysViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailCountrysScreen") as! DetailCountrysViewController
        return vc
    }
    @IBOutlet weak var CountryTable: UITableView!
    
    var url: String = ""
    let viewModel = DetailCountrysViewModel()
    var sunscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        onBInd()
        print("vuongdv",url)
    }
    private func updateUI() {
        setupCountryTable()
    }
    private func onBInd() {
        viewModel.passUrlPublisher.send(url)
        
        viewModel.dosomething.sink(receiveValue: {self.CountryTable.reloadData()}).store(in: &sunscriptions)
    }
    private func setupCountryTable() {
        CountryTable.delegate = self
        CountryTable.dataSource = self
    }
}
extension DetailCountrysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountry()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CountryTable.dequeueReusableCell(withIdentifier: "detailCoutryCell", for: indexPath) as! CountrysTableViewCell
        if let index = viewModel.cellOfCountry(indexPath.item) {
            cell.updateUI(index)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CountryTable.frame.height
    }
}
