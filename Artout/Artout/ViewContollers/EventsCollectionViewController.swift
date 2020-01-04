//
//  EventsCollectionViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/16/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift

private let reuseIdentifier = "EventCollectionCell"

class EventsCollectionViewController: UICollectionViewController {

    var selectedCell: Int = 0
    var viewModel = EventsViewModel()
    var disposeBag = DisposeBag()
    var refreshControlInstance = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        refreshControlInstance.addTarget(self, action: #selector(CallForRefresh), for: .valueChanged)
        collectionView.refreshControl = self.refreshControlInstance
        viewModel.FetchEvents()
        
        viewModel.refresh.subscribe(onNext: { (status) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionCell", for: indexPath) as! EventCollectionViewCell
        if viewModel.events.count > 0 {
            let item = viewModel.events[indexPath.row]
            ConfigureCell(for: cell, with: item)
        }
        return cell
    }
    
    func ConfigureCell(for cell: EventCollectionViewCell, with item: EventDetailEntity) {
        cell.titleLabel?.text = item.Title
        cell.dateLabel?.text = item.StartDate
        cell.descriptionLabel?.text = item.Description
    }
    
    @objc func CallForRefresh () {
        self.refreshControlInstance.beginRefreshing()
        self.viewModel.FetchEvents()
        self.refreshControlInstance.endRefreshing()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "EventDetail") as? EventDetailViewController
        viewController?.eventId = viewModel.events[indexPath.row].Id
        self.navigationController?.pushViewController(viewController!, animated: true)
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
