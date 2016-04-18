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

  @IBOutlet weak var cameraView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var shineLabel: RQShineLabel!
  @IBOutlet weak var snapGhost: DesignableImageView!
  
  var captureSession: AVCaptureSession?
  var stillImageOutput: AVCaptureStillImageOutput?
  var previewLayer: AVCaptureVideoPreviewLayer?
  
  
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
  }
  
  // MARK: - Shine Label
  
  func configureShineLabel() {
    shineLabel.backgroundColor = UIColor.clearColor()
    shineLabel.numberOfLines = 0
    shineLabel.text = "Snapchat"
    shineLabel.font = UIFont(name: "AvenirNext-Regular", size: 34.0)
    shineLabel.center = self.view.center
    shineLabel.shineDuration = 6.5
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
    print("scrollView Content Offset x-axis: \(scrollView.contentOffset.x)")
  }
}

extension ContainerViewController: LoginViewControllerDelegate, SignUpViewControllerDelegate {
  
  func userLoginAttempt(loginWasSuccessfull: Bool) {
    if loginWasSuccessfull {
      let happyGhost = UIImage(named: "happyghost")
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: happyGhost!)
    } else {
      let madGhost = UIImage(named: "madghost")
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: madGhost!)
    }
  }
  
  func userSignUpWasSuccessful(success: Bool) {
    if success {
      let happyGhost = UIImage(named: "happyghost")
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: happyGhost!)
    } else {
      let madGhost = UIImage(named: "madghost")
      Animator.animateGhostAfterLoginAttempt(snapGhost, forImage: madGhost!)
    }
  }
  
}

