//
//  MyFollowersTableViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyFollowersTableViewController: UITableViewController {

    var viewModel = MyFollowersViewModel()
    var disposeBag = DisposeBag()
    var refreshControlInstance = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.rowHeight = 100

        viewModel.FetchFollowers()
        viewModel.refresh.subscribe(onNext: { (status) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.Followers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell", for: indexPath) as! FollowersAndFollowingTableViewCell
        if viewModel.Followers.count > 0 {
            let item = viewModel.Followers[indexPath.row]
            ConfigureCell(for: cell, with: item)
        }
        return cell
    }

    func ConfigureCell(for cell: FollowersAndFollowingTableViewCell, with item: UserEntity) {
        cell.stateButton.layer.cornerRadius = 6
        cell.FFPhoto.layer.cornerRadius = cell.FFPhoto.frame.size.height / 2;
        cell.FFPhoto.clipsToBounds = true;
        cell.FFPhoto.layer.borderWidth = 3.0;
        cell.FFPhoto.layer.borderColor = UIColor.white.cgColor;
        cell.FFFullName?.text = item.FullName
        cell.UserId = String(item.Id)
        switch (item.State){
            case 1:
                cell.stateButton.isHidden = false
                cell.stateButton.setTitle("Following", for: .normal)
                cell.stateButton.backgroundColor = .white
                cell.stateButton.setTitleColor(.systemBlue, for: .normal)
                cell.stateButton.layer.borderWidth = 3
                cell.stateButton.layer.borderColor = UIColor.systemBlue.cgColor
            case 2:
                cell.stateButton.isHidden = false
                cell.stateButton.setTitle("Requested", for: .normal)
                cell.stateButton.backgroundColor = .white
                cell.stateButton.setTitleColor(.systemBlue, for: .normal)
                cell.stateButton.layer.borderWidth = 3
                cell.stateButton.layer.borderColor = UIColor.systemBlue.cgColor
            case 3:
                cell.stateButton.isHidden = false
                cell.stateButton.setTitle("Follow", for: .normal)
            default:
                cell.stateButton.isHidden = true
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
