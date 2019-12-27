//
//  EventsTableViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift

class EventsTableViewController: UITableViewController {

    var selectedCell: Int = 0
    var viewModel = EventsViewModel()
    var disposeBag = DisposeBag()
    var refreshControlInstance = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive &&
            (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for users or events"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = UIColor.white
        self.searchController.delegate = self
//        searchController.searchBar.barTintColor = UIColor.red
//        searchController.searchBar.scopeButtonTitles = ["Users", "Events"]
        searchController.searchBar.scopeButtonTitles = SearchContext.allCases
            .map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        refreshControlInstance.addTarget(self, action: #selector(CallForRefresh), for: .valueChanged)
        tableView.refreshControl = self.refreshControlInstance
        viewModel.FetchEvents()
        
        viewModel.refresh.subscribe(onNext: { (status) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }).disposed(by: disposeBag)

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredEvents.count
        }
        return viewModel.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        if isFiltering {
            if viewModel.filteredEvents.count > 0 {
                let item = viewModel.filteredEvents[indexPath.row]
                ConfigureCell(for: cell, with: item)
            }
        } else {
            if viewModel.events.count > 0 {
                let item = viewModel.events[indexPath.row]
                ConfigureCell(for: cell, with: item)
            }
        }
        
        return cell
        
    }
    
    func ConfigureCell(for cell: EventTableViewCell, with item: EventDetailEntity) {
        cell.TitleLabel?.text = item.Title
        cell.DateLabel?.text = item.StartDate
        cell.DescriptionLabel?.text = item.Description
    }
    
    @objc func CallForRefresh () {
        self.refreshControlInstance.beginRefreshing()
        self.viewModel.FetchEvents()
        self.refreshControlInstance.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "EventDetail") as? EventDetailViewController
        viewController?.eventId = viewModel.events[indexPath.row].Id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
extension EventsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let context = SearchContext(rawValue:
            searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
            viewModel.filterContentForSearchText(searchBar.text!, for: context)
    }
}
extension EventsTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        self.tableView.reloadData()
    }
}
extension EventsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let context = SearchContext(rawValue: searchBar.scopeButtonTitles![selectedScope])
    }
}

enum SearchContext: String, CaseIterable {
    case Events = "Events"
    case Users = "Users"
}

