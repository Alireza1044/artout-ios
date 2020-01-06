//
//  TimelineTableViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 1/5/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TimelineTableViewController: UITableViewController{
    var viewModel = EventsViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTimeline), for: .valueChanged)
        tableView.refreshControl = refreshControl
        viewModel.FetchEvents()
        viewModel.refresh.subscribe { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func refreshTimeline(){
        refreshControl?.beginRefreshing()
        viewModel.FetchEvents()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell",for: indexPath) as! TimelineTableViewCell
        if (viewModel.events.count > 0){
            let info = viewModel.events[indexPath.row]
            cell.titleLabel?.text = info.Title
            cell.dateLabel?.text = info.StartDate
            cell.descriptionLabel?.text = info.Description
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "TimelineDetail") as? TimelineDetailViewController
        viewController?.eventId = viewModel.events[indexPath.row].Id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}