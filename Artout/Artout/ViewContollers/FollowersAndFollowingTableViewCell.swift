//
//  FollowersAndFollowingTableViewCell.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift

class FollowersAndFollowingTableViewCell: UITableViewCell {

    var isFollowed: Bool = true
    let viewModel = MyFollowingsViewModel()
    var UserId: String = ""
    let service = FriendService()
    
    @IBOutlet weak var FFPhoto: UIImageView!
    @IBOutlet weak var FFFullName: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBAction func StateButtonAction(_ sender: Any) {
        switch self.stateButton.titleLabel?.text {
            case "Following":
                _ = service.Unfollow(with: String(self.UserId)).subscribe { (res) in
                    print("shit")
                }
                self.stateButton.setTitle("Follow", for: .normal)
            case "Requested":
                _ = service.CaancelFriendRequest(id: String(self.UserId)).subscribe { (res) in
                    print("shit")
                }
                self.stateButton.setTitle("Follow", for: .normal)
                break
            case "Follow":
                _ = service.AddFriend(id: String(self.UserId)).subscribe { (res) in
                    print("shit")
                }
                self.stateButton.setTitle("Requested", for: .normal)
            default:
                break
        }
//        viewModel.ChangeState(state: isFollowed, id: UserId)
//        self.isFollowed.toggle()
//        if isFollowed {
//            stateButton.setTitle("Following", for: .normal)
//        } else {
//            stateButton.setTitle("Follow", for: .normal)
//        }
        
    }
    override func prepareForReuse() {
        UserId = ""
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        FFPhoto.layer.masksToBounds = true
//        FFPhoto.layer.cornerRadius = FFPhoto.bounds.width / 2
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
