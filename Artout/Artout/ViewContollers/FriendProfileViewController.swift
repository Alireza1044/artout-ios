//
//  FriendProfileViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 12/22/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FriendProfileViewController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    var userId: Int = 0

    var viewModel = FriendProfileViewModel()
    var service = FriendService()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAvatar()
        viewModel.requestProfileDetail(id: self.userId)
        viewModel.profile.subscribe { (profile) in
            DispatchQueue.main.async {
//                if profile
                self.nameLabel.text = profile.element?.FullName
                self.followingButton.setTitle(String(profile.element!.FollowingCount), for: .normal)
                self.followersButton.setTitle(String(profile.element!.FollowerCount), for: .normal)
                
                switch (profile.element!.State){
                case 1:
                    self.followButton.isHidden = false
                    self.followButton.setTitle("Following", for: .normal)
                case 2:
                    self.followButton.isHidden = false
                    self.followButton.setTitle("Requested", for: .normal)
                case 3:
                    self.followButton.isHidden = false
                    self.followButton.setTitle("Follow", for: .normal)
                default:
                    self.followButton.isHidden = true
                }
                // set avatar
                // set follow button state
            }
        }.disposed(by: disposeBag)
    }
    @IBAction func followButtonPressed(_ sender: Any) {
        switch self.followButton.titleLabel?.text {
        case "Following":
            service.Unfollow(with: String(self.userId)).subscribe { (res) in
                print("shit")
            }
            self.followButton.setTitle("Follow", for: .normal)
        case "Requested":
            service.CaancelFriendRequest(id: String(self.userId)).subscribe { (res) in
                print("shit")
            }
            self.followButton.setTitle("Follow", for: .normal)
            break
        case "Follow":
            service.AddFriend(id: String(self.userId)).subscribe { (res) in
                print("shit")
            }
            self.followButton.setTitle("Requested", for: .normal)
        default:
            break
        }
    }
    
    func prepareAvatar(){
        self.avatar.layer.cornerRadius = avatar.frame.size.height / 2;
        self.avatar.clipsToBounds = true;
        self.avatar.layer.borderWidth = 3.0;
        self.avatar.layer.borderColor = UIColor .white.cgColor;
    }
}
