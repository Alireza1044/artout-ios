//
//  ViewController.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/31/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var validLabel: UILabel!
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = emailTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.emailText)
        _ = passwordTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.passwordText)
        _ = viewModel.isValid.bind(to: loginButton.rx.isEnabled)
        viewModel.isValid.subscribe(onNext: { [unowned self] isValid in
            self.validLabel.text = isValid ? "Password is valid" : "Password is not valid"
            self.validLabel.textColor = isValid ? .green : .red
        })
        .disposed(by: disposeBag)
    }


}

