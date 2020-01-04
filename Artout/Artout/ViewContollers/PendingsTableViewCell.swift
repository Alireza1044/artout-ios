//
//  PendingsTableViewCell.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/16/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit

class PendingsTableViewCell: UITableViewCell {

    let viewModel = PendingsViewModel()
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var acceptButtonOutlet: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var userId: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButtonOutlet.isHidden = true
        // Initialization code
    }

    override func prepareForReuse() {
        userId = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func acceptButtonPressed(_ sender: Any) {
        viewModel.AcceptWithID(Id: self.userId)
        doneButtonOutlet.isHidden = false
    }
    @IBAction func deleteButttonPressed(_ sender: Any) {
        viewModel.RejectWithID(Id: self.userId)
        acceptButtonOutlet.isHidden = true
        deleteButtonOutlet.isHidden = true
    }

}
