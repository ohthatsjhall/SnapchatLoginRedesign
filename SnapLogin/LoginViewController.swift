//
//  LoginViewController.swift
//  SnapLogin
//
//  Created by Justin Hall on 4/14/16.
//  Copyright © 2016 Justin Hall. All rights reserved.
//

import UIKit
import AVFoundation
import RQShineLabel
import TextFieldEffects
import Spring

protocol LoginViewControllerDelegate: class {
  func userLoginAttempt(loginWasSuccessfull: Bool)
}

class LoginViewController: UIViewController {

  @IBOutlet weak var usernameTextField: JiroTextField!
  @IBOutlet weak var passwordTextField: JiroTextField!
  @IBOutlet weak var loginButton: DesignableButton!
  
  weak var delegate: LoginViewControllerDelegate?
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
  }
  
  // MARK: - Actions
  
  @IBAction func loginButtonDidTouch(sender: DesignableButton) {
    if usernameTextField.text == "snapchat" && passwordTextField.text == "password" {
      delegate?.userLoginAttempt(true)
    } else {
      delegate?.userLoginAttempt(false)
    }
  }

}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    switch textField {
      
    case usernameTextField:
      passwordTextField.becomeFirstResponder()
      
    case passwordTextField:
      passwordTextField.resignFirstResponder()
      self.loginButtonDidTouch(loginButton)
      
    default:
      break
    }
    
    return true
  }
  
  // not technically UITextFieldDelegate Method, but it resigns keyboards if open.
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
}
