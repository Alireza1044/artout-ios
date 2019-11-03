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
    
    var signupViewMode = SignUpViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = firstNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewMode.firstNameText)
        _ = lastNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewMode.lastNameText)
        _ = phoneNumberTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewMode.phoneNumberText)
        _ = passwordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewMode.passwordText)
        _ = repeatPasswordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewMode.repeatPasswordText)
        
        signupViewMode.isSame.subscribe(onNext: { isEnabled in
            self.signupViewMode.isEmpty.subscribe(onNext: { isEmpty in
                self.registerButton.isEnabled = isEnabled && isEmpty
            })
            }).disposed(by: disposeBag)
    }
}
