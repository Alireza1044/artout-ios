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
    @IBAction func loginButtonPressed(_ sender: Any) {
        viewModel.Login()
        
    }
    var isLoggedIn: Bool = false
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = emailTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.usernameText)
        _ = passwordTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.passwordText)
        _ = viewModel.isValid.bind(to: loginButton.rx.isEnabled)
        
        viewModel.isValid.subscribe(onNext: { [unowned self] isValid in
            self.loginButton.isEnabled = isValid
        })
        .disposed(by: disposeBag)
        
        _ = viewModel.loginMessage.subscribe({ event in
            let alertController = UIAlertController(title: "Login Failed", message: event.element!
                , preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        })
        
        viewModel.loginStatus.subscribe({ status in
            switch status {
                case .next(true):
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "LoginToHomeSegue", sender: self)
                    }
                case .next(false): break 
                    
                case .error(_): break
                
                case .completed: break
                
            }
        })
        .disposed(by: disposeBag)
    }
}

