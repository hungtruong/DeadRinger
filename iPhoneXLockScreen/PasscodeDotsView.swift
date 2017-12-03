//
//  PasscodeDotsView.swift
//  iPhoneXLockScreen
//
//  Created by Hung Truong on 12/2/17.
//  Copyright © 2017 Hung Truong. All rights reserved.
//

import UIKit

class PasscodeDotsView: UIView {
    @IBOutlet var dot1: UIImageView!
    @IBOutlet var dot2: UIImageView!
    @IBOutlet var dot3: UIImageView!
    @IBOutlet var dot4: UIImageView!
    @IBOutlet var dot5: UIImageView!
    @IBOutlet var dot6: UIImageView!
    
    // This just makes it easier to deal with all of the UIImageViews
    func dotsAsArray() -> [UIImageView] {
        return [dot1, dot2, dot3, dot4, dot5, dot6]
    }
    
    // Toggle a dot at the index either on of off
    // I think the toggle on actually doesn't animate but I like the way it looks :p
    func toggleDot(index: Int, filled: Bool) {
        guard index < 6 else { return }
        let dot = dotsAsArray()[index]
        let newImage = filled ? #imageLiteral(resourceName: "dotopen") : #imageLiteral(resourceName: "dotclosed")
        UIView.transition(with: dot,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            dot.image = newImage
        },
                          completion: nil)
        
        UIView.animate(withDuration: 0.2) {
            if filled {
                dot.image = #imageLiteral(resourceName: "dotclosed")
            } else {
                dot.image = #imageLiteral(resourceName: "dotopen")
            }
        }
        
        
    }
    
}
