//
//  LoginViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/19.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI(){
        emailText.addTarget(self, action: #selector(handleTextFill), for: .editingChanged)
        passwordText.addTarget(self, action: #selector(handleTextFill), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
    }
    
    @objc func handleLogIn(){
        guard let email = emailText.text else{return}
        guard let password = passwordText.text else{return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error{
                print("Login Fail:",err)
                self.errorLabel.text = "Login Fail:\(err.localizedDescription)"
                return
            }
            print("Login Succese:",user ?? "")
            self.errorLabel.text = "Login Succese"
            self.performSegue(withIdentifier: "loginShowTabBarController", sender: nil)
        }
    
    }
    
    @objc func handleTextFill(){
        if let isEmailFill = emailText.text ,let isPasswordFill = passwordText.text{
            if isEmailFill.count > 0 && isPasswordFill.count > 0 {
                loginButton.isEnabled = true
                loginButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }else{
                loginButton.isEnabled = false
                loginButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
    }
    
}
