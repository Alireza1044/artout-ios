//
//  AddFriendViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    var viewModel = AddFriendViewModel()
    
    @IBOutlet weak var AddFriendSearchBar: UISearchBar!
    @IBOutlet weak var AddFriendSearchResultTableView: UITableView!
    @IBOutlet weak var AddFriendButton: UIButton!
    
    @IBAction func AddFriendButtonPressed(_ sender: Any) {
        viewModel.AddFriend()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        AddFriendSearchBar.placeholder = "Search for Friends"
        _ = AddFriendSearchBar.searchTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.searchText)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
