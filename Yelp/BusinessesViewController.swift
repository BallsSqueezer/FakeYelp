//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, FiltersViewControllerDelegate, UIScrollViewDelegate {
    
    //MARK: - Outlets and Variables
    @IBOutlet var tableView: UITableView!

    var businesses: [Business]!
    
    var  searchController: UISearchController!
    
    var isMoreDataLoading = false //this to determine if user is scroll -> trigger infinite scrolling
    var loadingMoreView: InfiniteScrollActivityView?
    
    var searchTerm = "cafe"
    
    //MARK: - Loading Views
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "green"))
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame: CGRectZero) //remove separator of empty cell
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Business.searchWithTerm(searchTerm, sort: nil, categories: nil, deals: false, offset: nil, radius: 16000) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.alpha = 0.0
            self.tableView.reloadData()
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            UIView.animateWithDuration(0.3, animations: { _ in
                self.tableView.alpha = 1.0
            })
        }
    
        //add search bar to navigation bar
        createSearchBar()
        navigationItem.titleView = searchController.searchBar
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var inset = tableView.contentInset
        inset.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = inset
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFilter" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filterViewController = navigationController.topViewController as! FiltersViewController
        
            filterViewController.delegate = self
        } else if segue.identifier == "ShowDetailBusiness" {
            let detailViewControllr = segue.destinationViewController as! BusinessDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                detailViewControllr.business = businesses[indexPath.row]
            }
        }
    }
    
    //MARK: - Helpers
    func createSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        //definesPresentationContext = true
        
        //customize search bar
        searchController.searchBar.placeholder = "Find your favourite restaurants..."
        searchController.searchBar.tintColor = AppThemes.textOrangeTheme
        searchController.searchBar.searchBarStyle = .Minimal
    }
    
    func loadMoreData(){        
        
        Business.searchWithTerm(searchTerm, sort: nil, categories: nil, deals: nil, offset: businesses.count, radius: nil, completion: { (businesses, error) in
            self.businesses.appendContentsOf(businesses)
            
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            self.loadingMoreView?.stopAnimating()
        })
    }
    
    func filterContentForSearchText(searchText: String){
        Business.searchWithTerm(searchText, sort: nil, categories: nil, deals: false, offset: nil, radius: 16000) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
        }
    }
    
    //MARK: - FiltersViewControllerDelegate
    func filtersViewController(filterViewController: FiltersViewController, didUpdateCategory categoryFilters: [String], withDeal deal: Bool, withDistance distance: Double) {
        
        print("update filter business")
        Business.searchWithTerm(searchTerm, sort: nil, categories: categoryFilters, deals: deal, offset: nil, radius: distance * 1609, completion: { (filteredBusinesses, error) in
                self.businesses = filteredBusinesses
                print("filteredBusinesses length: \(filteredBusinesses.count)")
                print("radius: \(distance)")
                self.tableView.reloadData()
        })
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading){
            // Calculate the position of scrollview where the date shoule start loading
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.dragging{
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more results
                loadMoreData()
            }
        }
        
    }
}

//MARK: - EXTENSION: UISearchResultsUpdating
extension BusinessesViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    
    }
}

//MARK: - EXTENSION: UITableViewDataSource, UITableViewDelegate
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate{
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            print(businesses.count)
            return businesses.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}




