//
//  AddFriendViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class AddFriendViewModel {
    var disposeBag = DisposeBag()
    var searchText = BehaviorSubject<String>(value: "")
    var addedSuccessfully: PublishSubject<Bool>
    
    init() {
        addedSuccessfully = PublishSubject<Bool>()
    }
    
    func AddFriend() {
//        Call Add Friend Service Function
        try? print(searchText.value())
    }
    
    
    
}
