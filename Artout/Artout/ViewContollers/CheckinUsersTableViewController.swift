//
//  CheckinUsersTableViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/7/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift

class CheckinUsersTableViewController: UITableViewController {

    var eventId: Int = 0
    var viewModel = CheckinUsersViewModel()
    var disposeBag = DisposeBag()
    var refreshControlInstance = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.refresh.subscribe(onNext: { (status) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.FetchEventCheckins(for: eventId)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserSearchTableViewCell
        
        if viewModel.users.count > 0 {
            let item = viewModel.users[indexPath.row]
            ConfigureUserCell(for: cell, with: item)
            return cell
        }
        return cell
    }
    
    func ConfigureUserCell(for cell: UserSearchTableViewCell, with item: UserEntity) {
        cell.UserSearchLabel!.text = item.FullName
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "FriendProfileViewController") as? FriendProfileViewController
        viewController?.userId = viewModel.users[indexPath.row].Id
        self.navigationController?.pushViewController(viewController!, animated: true)
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
