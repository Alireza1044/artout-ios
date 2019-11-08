//
//  EventTableViewCell.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var EventDateLabel: UILabel!
    @IBOutlet weak var EventTitleLabel: UILabel!
    @IBOutlet weak var EventImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
