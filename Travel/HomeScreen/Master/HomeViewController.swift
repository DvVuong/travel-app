//
//  HomeViewController.swift
//  Travel
//
//  Created by mr.root on 10/27/22.
//

import UIKit
import FirebaseAuth
import Combine

@available(iOS 13.0, *)
class HomeViewController: UIViewController {
    @IBOutlet private weak var lbUserName: UILabel!
    @IBOutlet private weak var imgUser: UIImageView!
    @IBOutlet private weak var countryCollection: UICollectionView!
    @IBOutlet private weak var viewSearch: UIView!
    @IBOutlet private weak var hobbyCollection: UICollectionView!
    @IBOutlet private weak var searchDestination: UITextField!
    @IBOutlet private weak var universeCollection: UICollectionView!
    @IBOutlet private weak var pageControll: UIPageControl!
    let  viewModel = HomeViewModel()
    var subcriptions = Set<AnyCancellable>()
    var timer: Timer?
    var currentIndexCell = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        onBind()
        viewModel.getUser()
        viewModel.getCountry()
        viewModel.getHobby()
        viewModel.getPlaneOfUniverse()
        //MARK: Timer
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(nextSlide), userInfo: nil, repeats: true)
       
        
        
    }
    
    private func updateUI() {
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.layer.masksToBounds = true
        imgUser.contentMode = .scaleToFill
        viewSearch.layer.cornerRadius = 8
        viewSearch.layer.masksToBounds = true
        setupCollection()
        // MARK: searchDestination
        searchDestination.addTarget(self, action: #selector(textFieldDidChangeForSearch(_:)), for: .editingChanged)
        setupImageUser()
        nextSlide()
       
    }
    private func onBind() {
        viewModel.userNamePublisher.assign(to: \.text, on: lbUserName).store(in: &subcriptions)
        viewModel.imgUserPublisher.sink { url in
            ImageCache.share.fetchImage(url) { image in
                DispatchQueue.main.async {
                    self.imgUser.image = image
                }
            }
        }.store(in: &subcriptions)
        viewModel.dosomething.sink(receiveValue: {self.countryCollection.reloadData()}).store(in: &subcriptions)
        viewModel.dosomething.sink(receiveValue: {self.hobbyCollection.reloadData()}).store(in: &subcriptions)
        viewModel.dosomething.sink(receiveValue: {self.universeCollection.reloadData()}).store(in: &subcriptions)
    }
    @objc func nextSlide(){
        if currentIndexCell < viewModel.planes.count - 1 {
            currentIndexCell = currentIndexCell + 1
        } else {
            currentIndexCell = 0
        }
       
        
        pageControll.currentPage = currentIndexCell
        universeCollection.scrollToItem(at: IndexPath(item: currentIndexCell, section: 0), at: .centeredHorizontally, animated: true)
    }
    private func setupImageUser(){
        imgUser.layer.borderWidth = 1
        imgUser.layer.borderColor = UIColor.black.cgColor
    }
   
    private func setupCollection(){
        countryCollection.delegate = self
        countryCollection.dataSource = self
        let nib = UINib(nibName: "CountryCollectionViewCell", bundle: nil)
        countryCollection.register(nib, forCellWithReuseIdentifier: "countryCell")
        // MARK: HobbyCollection
        hobbyCollection.delegate = self
        hobbyCollection.dataSource = self
        let hobbyNib = UINib(nibName: "HobbyCollectionViewCell", bundle: nil)
        hobbyCollection.register(hobbyNib, forCellWithReuseIdentifier: "hobbyCell")
        //MARK: UniverseCollection
        universeCollection.delegate = self
        universeCollection.dataSource = self
        universeCollection.isPagingEnabled = true
        let uinverserNib = UINib(nibName: "UniverseCell", bundle: nil)
        universeCollection.register(uinverserNib, forCellWithReuseIdentifier: "universeCell")
        
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        try? Auth.auth().signOut()
        view.window?.rootViewController?.dismiss(animated: true)
    }
    @objc private func textFieldDidChangeForSearch(_ textField: UITextField) {
        if textField === searchDestination {
            viewModel.searchHobby.send(textField.text ?? "")
        }
    }
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === countryCollection {
            return viewModel.numberOfsection()
        } else if collectionView === hobbyCollection {
            return viewModel.numberOfHobby()
        }else if collectionView === universeCollection {
            pageControll.numberOfPages = viewModel.numberOfUniverse()
            
            return viewModel.numberOfUniverse()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == countryCollection  {
            let cell = countryCollection.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionViewCell
            if let index = viewModel.cellForCountry(indexPath.item) {
                cell.updateUI(index)
            }
            return cell
        } else if collectionView == hobbyCollection {
            let cell = hobbyCollection.dequeueReusableCell(withReuseIdentifier: "hobbyCell", for: indexPath) as! HobbyCollectionViewCell
            if let index = viewModel.cellForHobby(indexPath.item) {
                cell.updateUI(index)
                
            }
            
            return cell
        } else {
            let cell = universeCollection.dequeueReusableCell(withReuseIdentifier: "universeCell", for: indexPath) as! UniverseCell
            if let index = viewModel.cellForUniverse(indexPath.item) {
                cell.updateUI(index)
            }
          
            
            //universeCollection.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .right, animated: true)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === countryCollection {
            return UIEdgeInsets(top: 5, left: 1, bottom: 1, right: 5)
        } else if collectionView === hobbyCollection{
            return UIEdgeInsets(top: 5, left: 1, bottom: 1, right: 5)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === hobbyCollection {
            let vc = DetailHobbysViewController.instance()
            if let index = viewModel.cellForHobby(indexPath.row) {
                vc.url = index.name
            }
            present(vc, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView === countryCollection {
            let vc = DetailCountrysViewController.instance()
            if let index = viewModel.cellForCountry(indexPath.row) {
                vc.url = index.name
                present(vc, animated: true, completion: nil)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === countryCollection {
            return CGSize(width: 130 , height: 190)
        }else if collectionView == hobbyCollection{
            return CGSize(width: 130 , height: 190)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    
}
