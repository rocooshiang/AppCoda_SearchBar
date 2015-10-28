//
//  ViewController.swift
//  CustomSearchBar
//
//  Created by Gabriel Theodoropoulos on 8/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate {
    
    //原始資料
    var dataArray = [String]()
    //有使用Search Controller時，需要顯示的資料
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        //載入資料
        loadListOfCountries()
        
        //設置search bar
        configureSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func loadListOfCountries() {
        // Specify the path to the countries list file.
        let pathToFile = NSBundle.mainBundle().pathForResource("countries", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            do {
                let countriesString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                // Append the countries from the string to the dataArray array by breaking them using the line change character.
                dataArray = countriesString.componentsSeparatedByString("\n")
                
                // Reload the tableview.
                tblSearchResults.reloadData()
            }catch (let error){
                print("Error: \(error)")
            }
            
        }
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //輸入搜尋關鍵字的時候，讓整個view背景變得黯淡
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "請輸入關鍵字..."
        searchController.searchBar.delegate = self
        //讓搜尋列(search bar)的尺寸跟tableview所顯示的尺寸一致
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    //開始搜尋時，使用dataArray作為tableView資料來源
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    //Cancel後，使用filteredArray作為tableView資料來源
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //在我們按下搜尋按鈕之後，我們會禁用即時搜功能(real-time searching)尋並只顯示搜尋結果。
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        //重行指派搜尋欄位的first responder來隱藏鍵盤
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country
            
            return (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
}

