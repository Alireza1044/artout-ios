//
//  SignUpViewController.swift
//  
//
//  Created by Alireza Moradi on 11/3/19.
//

import RxSwift
import RxCocoa
import UIKit

class SignUpViewController: UIViewController{
    

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var signupViewModel = SignUpViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = firstNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.firstNameText)
        _ = lastNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.lastNameText)
        _ = phoneNumberTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.phoneNumberText)
        _ = passwordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.passwordText)
        _ = repeatPasswordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.repeatPasswordText)
        
//        self.registerButton.isEnabled = Observable.combineLatest(signupViewModel.isSame,signupViewModel.isEmpty) { isSame, isEmpty in
//            isSame && isEmpty
//        }

        signupViewModel.isSame.subscribe(onNext: { isEnabled in
            self.signupViewModel.isEmpty.subscribe(onNext: { isEmpty in
                self.registerButton.isEnabled = isEnabled && isEmpty
            })
            }).disposed(by: disposeBag)
    }
}
