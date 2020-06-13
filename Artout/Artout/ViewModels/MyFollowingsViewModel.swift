//
//  MyFollowingsViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class MyFollowingsViewModel {
    let refresh: PublishSubject<Bool>
    var disposeBag = DisposeBag()
    var Followings: [UserEntity]
    let service = FriendService()
    
    init() {
        self.Followings = []
        self.refresh = PublishSubject<Bool>()

    }
    func ChangeState(state: Bool, id: String) {
        if state {
            _ = service.Unfollow(with: id).subscribe(onSuccess: { (bool) in
                self.refresh.onNext(true)
            })
        } else {
            _ = service.AddFriend(id: id).subscribe(onSuccess: { (bool) in
                self.refresh.onNext(true)
            })
        }
    }
    func FetchFollowings() {
        _ = service.fetchFollowingList().subscribe(onSuccess: { data in
            self.Followings = data
            self.refresh.onNext(true)
        })
    }
}
