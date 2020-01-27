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
                self.stateButton.backgroundColor = .systemBlue
                self.stateButton.setTitleColor(.white, for: .normal)
            case "Requested":
                _ = service.CaancelFriendRequest(id: String(self.UserId)).subscribe { (res) in
                    print("shit")
                }
                self.stateButton.setTitle("Follow", for: .normal)
                self.stateButton.backgroundColor = .systemBlue
                self.stateButton.setTitleColor(.white, for: .normal)
                break
            case "Follow":
                _ = service.AddFriend(id: String(self.UserId)).subscribe { (res) in
                    print("shit")
                }
                self.stateButton.setTitle("Requested", for: .normal)
                self.stateButton.backgroundColor = .black
                self.stateButton.setTitleColor(.systemBlue, for: .normal)
                self.stateButton.layer.borderWidth = 3
                self.stateButton.layer.borderColor = UIColor.systemBlue.cgColor
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
        self.stateButton.layer.cornerRadius = 6
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
