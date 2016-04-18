//
//  Animator.swift
//  SnapLogin
//
//  Created by Justin Hall on 4/17/16.
//  Copyright © 2016 Justin Hall. All rights reserved.
//

import Foundation
import Spring

class Animator {
  class func animateGhostAfterLoginAttempt(snapGhost: DesignableImageView, forImage ghostImage: UIImage) {
    snapGhost.image = ghostImage
    snapGhost.animation = "pop"
    snapGhost.animationDuration = 1.0
    snapGhost.animate()
  }
}
