//
//  ProfileViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saulehImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    let headerViewMaxHeight: CGFloat = 320
    var headerViewMinHeight: CGFloat = 97 + (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
    
    var alpha: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    var disposeBag = DisposeBag()
    var viewModel = FriendProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestProfileDetail(id: UserDefaults.standard.integer(forKey: "UserId"))
        viewModel.profile.subscribe{ profile in
            DispatchQueue.main.async { self.followersButton.setTitle(String(profile.element!.FollowerCount), for: .normal)
                self.followingButton.setTitle(String(profile.element!.FollowingCount), for: .normal)
                
                self.nameLabel.text = profile.element!.FullName
            }
        }.disposed(by: disposeBag)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        alpha = saulehImage.alpha
        height = saulehImage.frame.size.height / 2
        self.saulehImage.layer.cornerRadius = height;
        self.saulehImage.clipsToBounds = true;
        self.saulehImage.layer.borderWidth = 3.0;
        self.saulehImage.layer.borderColor = UIColor .white.cgColor;
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = headerViewHeightConstraint.constant - y
        
        if newHeaderViewHeight > headerViewMaxHeight {
            headerViewHeightConstraint.constant = headerViewMaxHeight
            saulehImage.alpha = (alpha * (headerViewHeightConstraint.constant) / headerViewMaxHeight)
        } else if newHeaderViewHeight < headerViewMinHeight {
            headerViewHeightConstraint.constant = headerViewMinHeight
            saulehImage.alpha = (alpha * (headerViewHeightConstraint.constant - headerViewMinHeight) / headerViewMaxHeight)
            
        } else {
            headerViewHeightConstraint.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
            saulehImage.alpha = (alpha * (headerViewHeightConstraint.constant) / headerViewMaxHeight)
        }
    }
}

