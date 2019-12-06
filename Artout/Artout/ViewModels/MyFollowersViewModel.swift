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
    
    var disposeBag = DisposeBag()
    var Followers: [UserEntity]
    
    init() {
        self.Followers = []
    }
    
    func FetchFollowers() {
        
    }
}
