//
//  ViewController.swift
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

class ContainerViewController: UIViewController {
  
  @IBOutlet weak var signupButton: DesignableButton!

  @IBOutlet weak var cameraView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var shineLabel: RQShineLabel!
  @IBOutlet weak var snapGhost: DesignableImageView!
  
  var signUpIsPresented = false
  
  var captureSession: AVCaptureSession?
  var stillImageOutput: AVCaptureStillImageOutput?
  var previewLayer: AVCaptureVideoPreviewLayer?
  
  var containerSize: CGFloat = 0.0 {
    didSet {
      let maxAlpha: CGFloat = 0.97
      let minAlpha: CGFloat = 0.01
      signupButton.alpha = calculateAlphaUsingScrollView(
        scrollView,
        withAlphaForOffsetZero: maxAlpha,
        withAlphaForOffsetMax: minAlpha)
    }
  }
  
  // MARK: View Controller Lifecycle
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupCaptureSession()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    previewLayer?.frame = cameraView.bounds
    shineLabel.shineWithCompletion {
      self.shineLabel.fadeOut()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureShineLabel()
    configureScrollViewForLogin()
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  // MARK: - Actions
  
  @IBAction func signUpButtonDidTouch(sender: DesignableButton) {
    scrollToSignUpView()
  }
  
  func scrollToSignUpView() {
    
    UIView.animateWithDuration(0.80, delay: 0.0, usingSpringWithDamping: 0.667, initialSpringVelocity: 0.0, options: [], animations: {
      
      if !self.signUpIsPresented {
        self.scrollView.contentOffset.x = self.view.frame.width
      } else {
        self.scrollView.contentOffset.x = 0.0
      }
      
      }, completion: nil)
  }
  
  // MARK: - ScrollView Navigation
  
  func configureScrollViewForLogin() {
    
    let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    // add the first view controller to the parent view & scroll view
    // set the LoginViewController's delegate to the ContainerViewController(self)
    loginViewController.delegate = self
    self.addChildViewController(loginViewController)
    scrollView.addSubview(loginViewController.view)
    loginViewController.didMoveToParentViewController(self)
    
    
    let width = self.view.frame.size.width
    let height = self.view.frame.size.height
    
    let signUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
    // make the origin of the second view controller to the outer frame of the first view controller
    // when you scroll, the start of the second view controller will be where the first one ends.
    // set the SignUpViewController Delegate to ContainerViewController(self)
    signUpViewController.delegate = self
    var frame1 = signUpViewController.view.frame
    frame1.origin.x = self.view.frame.size.width
    signUpViewController.view.frame = frame1
    
    self.addChildViewController(signUpViewController)
    scrollView.addSubview(signUpViewController.view)
    signUpViewController.didMoveToParentViewController(self)
    
    // replace number '2' with how many views you'd like in your scroll view.
    scrollView.contentSize = CGSizeMake(width * 2, height)
    containerSize = scrollView.contentSize.width / 2
  }
  
  // MARK: - Shine Label
  
  func configureShineLabel() {
    shineLabel.backgroundColor = UIColor.clearColor()
    shineLabel.numberOfLines = 0
    shineLabel.text = "Snapchat"
    shineLabel.font = UIFont(name: "AvenirNext-Regular", size: 35.0)
    shineLabel.center = self.view.center
    shineLabel.shineDuration = 7.0
    shineLabel.sizeToFit()
    view.addSubview(shineLabel)
  }

  // MARK: - Capture Session
  func setupCaptureSession() {
    captureSession = AVCaptureSession()
    captureSession?.sessionPreset = AVCaptureSessionPresetHigh
    
    let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    do {
      let input = try AVCaptureDeviceInput(device: backCamera)
      
      if captureSession!.canAddInput(input){
        captureSession!.addInput(input)
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        
        if ((captureSession?.canAddOutput(stillImageOutput)) != nil) {
          captureSession?.addOutput(stillImageOutput)
          previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
          if let previewLayer = previewLayer {
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
            previewLayer.connection.videoOrientation = .Portrait
            cameraView.layer.addSublayer(previewLayer)
            captureSession?.startRunning()
          }
        }
      }
    } catch { print("error with capture session: \(error)") }
  }
  
  
}

extension ContainerViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    
    let maxAlpha: CGFloat = 0.97
    let minAlpha: CGFloat = 0.01
    if scrollView.contentOffset.x >= containerSize / 2 {
      signupButton.setTitle("Already have an account?", forState: .Normal)
      signupButton.alpha = calculateAlphaUsingScrollView(
        scrollView,
        withAlphaForOffsetZero: minAlpha,
        withAlphaForOffsetMax: maxAlpha)
      signUpIsPresented = true
      
    } else {
      
      signupButton.setTitle("Don't have an account yet?", forState: .Normal)
      signupButton.alpha = calculateAlphaUsingScrollView(
        scrollView,
        withAlphaForOffsetZero: maxAlpha,
        withAlphaForOffsetMax: minAlpha)
      signUpIsPresented = false
    }
    
  }
  
  func calculateAlphaUsingScrollView(scrollView: UIScrollView, withAlphaForOffsetZero alphaForOffsetZero: CGFloat, withAlphaForOffsetMax alphaForOffsetMax: CGFloat) -> CGFloat {
    let width = scrollView.frame.size.width
    let contentWidth = scrollView.contentSize.width
    let scrollLength = contentWidth - width
    let scrollOffset = scrollView.contentOffset.x
    let scrollValue = scrollOffset / scrollLength
    let alphaChange = alphaForOffsetMax - alphaForOffsetZero
    let finalAlpha = alphaForOffsetZero + alphaChange * scrollValue

    return finalAlpha
  }

}



extension ContainerViewController: LoginViewControllerDelegate, SignUpViewControllerDelegate {
  
  func userLoginAttempt(success: Bool) {
    if success {
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: UIImage(named: "happyghost")!)
    } else {
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: UIImage(named: "madghost")!)
    }
  }
  
  func userSignUpWasSuccessful(success: Bool) {
    if success {
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: UIImage(named: "happyghost")!)
    } else {
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: UIImage(named: "madghost")!)
    }
  }
  
}

