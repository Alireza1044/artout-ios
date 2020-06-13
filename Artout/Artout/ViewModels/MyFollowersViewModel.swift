//
//  MyFollowersViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class MyFollowersViewModel {
    let refresh: PublishSubject<Bool>
    var disposeBag = DisposeBag()
    var Followers: [UserEntity]
    var service = FriendService()
    
    init() {
        self.Followers = []
        self.refresh = PublishSubject<Bool>()
    }
    
    func FetchFollowers() {
        _ = service.fetchFollowersList().subscribe(onSuccess: { data in
            self.Followers = data
            self.refresh.onNext(true)
        })
    }
}
