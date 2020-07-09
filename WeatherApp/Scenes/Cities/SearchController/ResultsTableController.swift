//
//  ResultsTableController.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 7/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

class ResultsTableController: UITableViewController, ResultsView {
    var presenter: ResultsPresenter!
    var configurator: ResultsConfigurator!
    
    weak var citiesTableController: CitiesTableViewController?
    var typingThrottler: TypingThrottler?
    
    func displayAddCityError(title: String, message: String) {
        print("displayAddCityError")
    }
    
    func refreshResults() {
        print("ResultsTableController refreshResults")
        tableView.reloadData()
    }
    
    var filteredProducts = [City]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(resultsTableController: self, citiesTableController: citiesTableController)
        
        //'throttle' search requests to be delayed by a period of time after the user has stopped typing
        // In this case we only sending the latest request when 0.3 seconds has elapsed
        typingThrottler = TypingThrottler(interval: 0.3, handler: presenter.searchTextDidChange(searchText:))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection = \(presenter.numberOfResults)")
        return presenter.numberOfResults
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCityTableViewCell", for: indexPath) as! ResultCityTableViewCell
        presenter.configure(cell: cell, forRow: indexPath.row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         presenter.cityDidSelect(at: indexPath.row)
    }

}

extension ResultsTableController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text!
        print("searchString = \(searchString)")
        
        //API accepts search strings above 3 letters
        guard searchString.count > 2 else{
            return
        }
        
        typingThrottler?.handleTyping(with: searchString)
        
    }
}
