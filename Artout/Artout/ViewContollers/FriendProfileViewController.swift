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
                // set avatar
                // set follow button state
            }
        }.disposed(by: disposeBag)
    }
    
    func prepareAvatar(){
        self.avatar.layer.cornerRadius = avatar.frame.size.height / 2;
        self.avatar.clipsToBounds = true;
        self.avatar.layer.borderWidth = 3.0;
        self.avatar.layer.borderColor = UIColor .white.cgColor;
    }
}
