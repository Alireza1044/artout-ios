//
//  FriendProfileViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 12/22/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class FriendProfileViewModel{
    
    var followerCount: BehaviorSubject<String>
    var followingCount: BehaviorSubject<String>
    var name: BehaviorSubject<String>
    var username: BehaviorSubject<String>
    var state: BehaviorSubject<String>
    
    var isLoading: PublishSubject<Bool>
    var profile: BehaviorSubject<FriendProfileEntity>
    
    var service = ProfileService()
    var disposeBag = DisposeBag()
    
    init() {
        followerCount = BehaviorSubject<String>(value: "")
        followingCount = BehaviorSubject<String>(value: "")
        name = BehaviorSubject<String>(value: "")
        username = BehaviorSubject<String>(value: "")
        state = BehaviorSubject<String>(value: "")
        isLoading = PublishSubject<Bool>()
        profile = BehaviorSubject<FriendProfileEntity>(value: FriendProfileEntity(FirstName: "",
                                                                                  LastName: "",
                                                                                  UserName: "",
                                                                                  Avatar: "",
                                                                                  FollowerCount: 0,
                                                                                  FollowingCount: 0,
                                                                                  Id: -1, State: -1))
    }
    
    func requestProfileDetail(id: Int){
        
        service.isLoading.subscribe({
            switch $0{
            case .next(true):
                self.isLoading.on(.next(true))
            case .next(false):
                self.isLoading.on(.next(false))
            default:
                self.isLoading.on(.next(false))
            }
        }).disposed(by: disposeBag)
        
        service.RequestProfile(id: id).subscribe(onSuccess: { (friendProfile) in
            self.profile.onNext(friendProfile)
        }, onError: self.profile.onError(_:)).disposed(by: disposeBag)
    }
}
