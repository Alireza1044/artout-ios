//
//  TimelineTableViewCell.swift
//  Artout
//
//  Created by Alireza Moradi on 1/5/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TimelineTableViewCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
