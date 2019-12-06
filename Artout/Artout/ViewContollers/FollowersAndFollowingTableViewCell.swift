//
//  FollowersAndFollowingTableViewCell.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit

class FollowersAndFollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var FFPhoto: UIImageView!
    @IBOutlet weak var FFFullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FFPhoto.layer.masksToBounds = true
        FFPhoto.layer.cornerRadius = FFPhoto.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
