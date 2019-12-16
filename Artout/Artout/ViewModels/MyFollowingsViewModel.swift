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
    
    var disposeBag = DisposeBag()
    var Followings: [UserEntity]
    let service = FriendService()
    
    init() {
        self.Followings = []
    }
    
    func FetchFollowings() {
        _ = service.fetchFollowingList().subscribe(onSuccess: { data in
            self.Followings = data
        })
    }
}
