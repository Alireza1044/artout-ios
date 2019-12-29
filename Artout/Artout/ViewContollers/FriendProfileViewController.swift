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
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var userId: Int = 0

    var viewModel = FriendProfileViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAvatar()
        viewModel.requestProfileDetail(id: self.userId)
        viewModel.profile.subscribe { (profile) in
            DispatchQueue.main.async {
//                if profil
                self.nameLabel.text = profile.element?.FullName
                self.followersButton.titleLabel?.text = profile.element!.FollowerCount
                self.followingButton.titleLabel?.text = profile.element!.FollowingCount
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
