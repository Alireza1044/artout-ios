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
    
    @IBOutlet weak var checkinButton: UIButton!
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
        self.checkinButton.backgroundColor = .systemBlue
        self.checkinButton.setTitleColor(.white, for: .normal)
        self.checkinButton.layer.cornerRadius = 6
        self.followButton.layer.cornerRadius = 6
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
                    self.checkinButton.isHidden = false;
                    self.followButton.backgroundColor = .black
                    self.followButton.setTitleColor(.systemBlue, for: .normal)
                    self.followButton.layer.borderWidth = 3
                    self.followButton.layer.borderColor = UIColor.systemBlue.cgColor
                case 2:
                    self.followButton.isHidden = false
                    self.followButton.setTitle("Requested", for: .normal)
                    self.checkinButton.isHidden = true;
                    self.followButton.backgroundColor = .black
                    self.followButton.setTitleColor(.systemBlue, for: .normal)
                    self.followButton.layer.borderWidth = 3
                    self.followButton.layer.borderColor = UIColor.systemBlue.cgColor
                case 3:
                    self.followButton.isHidden = false
                    self.followButton.setTitle("Follow", for: .normal)
                    self.checkinButton.isHidden = true;
                default:
                    self.followButton.isHidden = true
                    self.checkinButton.isHidden = true
                }
                // set avatar
                // set follow button state
            }
        }.disposed(by: disposeBag)
    }
    @IBAction func followButtonAction(_ sender: Any) {
        switch self.followButton.titleLabel?.text {
            case "Following":
                service.Unfollow(with: String(self.userId)).subscribe { (res) in
                    print("shit")
                }
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.backgroundColor = .systemBlue
            self.followButton.setTitleColor(.white, for: .normal)
            case "Requested":
                service.CaancelFriendRequest(id: String(self.userId)).subscribe { (res) in
                    print("shit")
                }
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.backgroundColor = .systemBlue
                self.followButton.setTitleColor(.white, for: .normal)
                break
            case "Follow":
                service.AddFriend(id: String(self.userId)).subscribe { (res) in
                    print("shit")
                }
                self.followButton.setTitle("Requested", for: .normal)
                self.followButton.backgroundColor = .black
                self.followButton.setTitleColor(.systemBlue, for: .normal)
                self.followButton.layer.borderWidth = 3
                self.followButton.layer.borderColor = UIColor.systemBlue.cgColor
            default:
                break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserCheckinSegue" {
            let destination = segue.destination as! CheckinEventTableViewController
            destination.usrId = self.userId
        }
    }
    func prepareAvatar(){
        self.avatar.layer.cornerRadius = avatar.frame.size.height / 2;
        self.avatar.clipsToBounds = true;
        self.avatar.layer.borderWidth = 3.0;
        self.avatar.layer.borderColor = UIColor .white.cgColor;
    }
}
