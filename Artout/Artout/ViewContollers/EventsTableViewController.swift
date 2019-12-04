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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
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
        return viewModel.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        if viewModel.events.count > 0 {
            let item = viewModel.events[indexPath.row]
            ConfigureCell(for: cell, with: item)
        }
        return cell
        
    }
    
    func ConfigureCell(for cell: EventTableViewCell, with item: EventResponse) {
        cell.TitleLabel?.text = item.title
        cell.DateLabel?.text = item.start_date
        cell.DescriptionLabel?.text = item.description
    }
    
    @objc func CallForRefresh () {
        self.refreshControlInstance.beginRefreshing()
        self.viewModel.FetchEvents()
        self.refreshControlInstance.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "EventDetail") as? EventDetailViewController
        viewController?.eventId = viewModel.events[indexPath.row].id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
