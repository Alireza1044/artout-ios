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
    
    init() {
        self.Followings = []
    }
    
    func FetchFollowings() {
        
    }
}
