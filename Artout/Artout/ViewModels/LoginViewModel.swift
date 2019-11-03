//
//  LoginViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/31/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    var emailText: BehaviorSubject<String>
    var passwordText: BehaviorSubject<String>
    var isValid: Observable<Bool>
    var loginStatus: PublishSubject<Bool>
    var service = TokenService()
    
    init() {
        emailText = BehaviorSubject<String>(value: "")
        passwordText = BehaviorSubject<String>(value: "")
        loginStatus = PublishSubject<Bool>()
        self.isValid = Observable.combineLatest(emailText.asObservable(),passwordText.asObservable()) { email, password in
            password.count >= 8
        }
    }
    
    func Login() {
        try? service.FetchToken(With: emailText.value(), And: passwordText.value())
            .subscribe { event in
                switch event {
                    case .success:
                        self.loginStatus.on(.next(true))
                    case .error:
                        self.loginStatus.on(.next(false))
                }
        }
        
    }
    
}
