//
//  SignUpViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 11/3/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModel{
    var firstNameText: BehaviorSubject<String>
    var lastNameText: BehaviorSubject<String>
    var phoneNumberText: BehaviorSubject<String>
    var passwordText: BehaviorSubject<String>
    var repeatPasswordText: BehaviorSubject<String>
    
    var isSame: Observable<Bool>
    var isEmpty: Observable<Bool>
    
    var service = RegisterService()
    
    init() {
        firstNameText = BehaviorSubject<String>(value: "")
        lastNameText = BehaviorSubject<String>(value: "")
        phoneNumberText = BehaviorSubject<String>(value: "")
        passwordText = BehaviorSubject<String>(value: "")
        repeatPasswordText = BehaviorSubject<String>(value: "")
        
        self.isSame = Observable.combineLatest(passwordText.asObservable(),repeatPasswordText.asObservable()) { password, repeatPassword in
            password == repeatPassword
        }
        
        self.isEmpty = Observable.combineLatest(firstNameText.asObservable(),lastNameText.asObservable(),phoneNumberText.asObservable()) { first,last,phone in
            first.isEmpty &&
            last.isEmpty &&
            phone.isEmpty
        }
    }
    
    func Register() {
        //service.Register(firstName: self.firstNameText , lastName: self.lastNameText, phoneNumber: self.phoneNumberText, password: self.passwordText)
    }
}
