//
//  SearchReminderGramViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 11/8/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "searchCollectionViewCell"

class SearchReminderGramViewController: UIViewController, UISearchResultsUpdating {

    // MockData
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var searching = false
    var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
        
        setupCollectionView()
    }
    
    
    // MARK: - Set Up CollectionView
    lazy var resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout.init()
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: SearchReminderGramLayout.init())
        view.delegate = self
        view.dataSource = self
        view.register(SearchReminderGramsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return view
    }()
    
    fileprivate func setupCollectionView() {
        view.addSubview(resultsCollectionView)
        resultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        resultsCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        resultsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        resultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        resultsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    // MARK: - Functions
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.searchResultsController?.view.isHidden = false
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredData.removeAll()
            for item in data {
                if item.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(item)
                }
            }
            searching = true
            print(searchText)
            print(filteredData)
        } else {
            searching = false
        }
        
        DispatchQueue.main.async {
            self.resultsCollectionView.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
}

extension SearchReminderGramViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return searching ? filteredData.count : data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SearchReminderGramsCollectionViewCell
        
        // Configure the cell
        let filteredDataItem = searching ? filteredData[indexPath.row] : data[indexPath.row]
        cell?.textLabel.text = filteredDataItem
        
        return cell ?? UICollectionViewCell()
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
