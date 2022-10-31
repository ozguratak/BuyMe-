//
//  SearchViewController.swift
//  BuyMe!
//
//  Created by obss on 28.10.2022.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var item = Items.shared //singleton
    var allItems = ItemsTableViewController().itemsArray
    var searchResultItems: [Items] = []
    var searchText: String? = ""
    
    let searchbarController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchBar.delegate = self
        searchResultItems.removeAll()
    }
    
    //MARK: - SearchBar controllers
    private func searchBarControls() {
        
        if searchBar.text != nil {
            searchbarController.automaticallyShowsCancelButton = true
          
            if !searchbarController.isEditing {
                searchResult()
                pageContentController()
            }
        }
    }
    
    private func searchResult() {
        
        if searchBar.text != nil {
            searchText = characterCheck(text: searchBar.text!)
            
            for item in allItems {
                if characterCheck(text: item.description) == searchText {
                    self.searchResultItems.append(item)
                }
            }
            pageContentController()
            self.searchResultTableView.reloadData()
        }
    }
    
    //MARK: - Helpers and Page content control
    func characterCheck(text: String) -> String { // ascii-7 olmayan karakterlerin düzeltilmesi
        var correctedText: String = ""
        for ch in text {
            if ch.isASCII == true {
                correctedText += ch.description.lowercased()
            } //ascii olmaması durumunda convert etmek ve eklemek gerekiyor.
        }
        return correctedText
    }
    
    private func pageContentController() {
        
        if searchResultItems.isEmpty { 
            emptyView.isHidden = false
            informationLabel.isHidden = false
            searchBar.isHidden = true
            searchResultTableView.isHidden = true
        } else {
            emptyView.isHidden = true
            informationLabel.isHidden = true
            searchBar.isHidden = false
            searchResultTableView.isHidden = false
        }
    }
    
    private func allItemsDownload() {
        
        item.downloadItemsFromFirebase { itemsArray in
            for items in itemsArray {
                self.allItems.append(items)
            }
        }
    }
    
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResultItems.count > 0 {
            return searchResultItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Skeleton.startAnimation(outlet: searchResultTableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! TableViewCell
        if !searchResultItems.isEmpty {
            cell.cellConfigure(searchResultItems[indexPath.row])
        } else {
            cell.defaultCell()
        }
        Skeleton.stopAnimaton(outlet: searchResultTableView)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if allItems.isEmpty {
            allItemsDownload()
            return
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchbarController.automaticallyShowsSearchResultsController = true
        searchResult()
        return
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchBar.text?.isEmpty == true || searchBar.text == " " {
            searchResultItems.removeAll()
            searchResultTableView.reloadData()
           
        }
        let bottomOffset = CGPoint(x: 0, y: 0)
        searchResultTableView.setContentOffset(bottomOffset, animated: true)
        if searchText.count >= 1{
        } else {
           
        }
    }
}
