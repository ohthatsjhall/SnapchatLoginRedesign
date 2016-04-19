//
//  SignUpViewController.swift
//  SnapLogin
//
//  Created by Justin Hall on 4/17/16.
//  Copyright © 2016 Justin Hall. All rights reserved.
//

import UIKit
import Spring
import TextFieldEffects

protocol SignUpViewControllerDelegate: class {
  func userSignUpWasSuccessful(success: Bool)
}

class SignUpViewController: UIViewController {
  
  
  
  
  @IBOutlet weak var emailAddressTextField: JiroTextField!
  @IBOutlet weak var passwordTextField: JiroTextField!
  @IBOutlet weak var signUpButton: DesignableButton!
  
  weak var delegate: SignUpViewControllerDelegate?

  override func viewDidLoad() {
      super.viewDidLoad()

  }

    
  @IBAction func signUpButtonDidTouch(sender: DesignableButton) {
    passwordTextField.text?.length >= 8 ? delegate?.userSignUpWasSuccessful(true) : delegate?.userSignUpWasSuccessful(false)
  }

  

}


extension SignUpViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    switch textField {
      
    case emailAddressTextField:
      passwordTextField.becomeFirstResponder()
      
    case passwordTextField:
      passwordTextField.resignFirstResponder()
      self.signUpButtonDidTouch(signUpButton)
      
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