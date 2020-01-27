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
    var viewModel = TimelineViewModel()
    var disposeBag = DisposeBag()
    var pageNo = 1
    var pageSize = 10
    var fetchMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTimeline), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshTimeline(){
        refreshControl?.beginRefreshing()
        viewModel.events = []
        pageNo = 1
        fetchMore = false
        viewModel.FetchEvents(pageNo: pageNo,pageSize: pageSize)
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height{
            if (!fetchMore){
                fetchMore = true
                print("Fucking printing \(pageNo)")
                viewModel.FetchEvents(pageNo: pageNo,pageSize: pageSize)
                viewModel.refresh.subscribe { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.perform(#selector(self.reloadTable), with: nil, afterDelay: 1.0)
                        self.tableView.reloadData()
                    })
                }.disposed(by: disposeBag)
                if (self.viewModel.events.count >= (pageNo - 1) * pageSize){
                    self.fetchMore = false
                    print("fuck")
                }
                self.pageNo += 1
            }
        }
    }
    
    @objc func reloadTable(){
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Events", bundle: nil)
        let viewController = s.instantiateViewController(identifier: "OtherEventDetail") as? OtherEventDetailViewController
        viewController?.eventId = viewModel.events[indexPath.row].Id
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
