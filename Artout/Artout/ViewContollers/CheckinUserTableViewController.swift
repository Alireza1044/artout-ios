//
//  CheckinUserTableViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/27/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import UIKit

class CheckinUserTableViewController: UITableViewController {

    var eventId = 0
    var viewModel = CheckinViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.FetchEventCheckins(for: eventId)
        
        viewModel.reload.subscribe(onNext: { (reload) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.checkinObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! FollowersAndFollowingTableViewCell

        if viewModel.checkinObjects.count > 0 {
            ConfigureCell(for: cell, with: viewModel.checkinObjects[indexPath.row].User)
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if String(viewModel.checkinObjects[indexPath.row].User.Id) == UserDefaults.standard.string(forKey: "UserId") {
//            let x = UIStoryboard(name: "Profile", bundle: nil)
//            let viewController = x.instantiateViewController(identifier: "MyProfileViewController") as? ProfileViewController
//            viewController?.navigationController?.setNavigationBarHidden(false, animated: false)
//            self.navigationController?.pushViewController(viewController!, animated: true)
        } else {
            let viewController = storyboard?.instantiateViewController(identifier: "FriendProfileViewController") as? FriendProfileViewController
            viewController?.userId = viewModel.checkinObjects[indexPath.row].User.Id
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
