//
//  KeypadButton.swift
//  iPhoneXLockScreen
//
//  Created by Hung Truong on 12/1/17.
//  Copyright © 2017 Hung Truong. All rights reserved.
//

import UIKit

@IBDesignable
class KeypadButton: UIButton {
    let defaultColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    let highlightColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)

    // Lots of hardcoded #s but it's from tweaking a bunch until my buttons looked the same...
    func setTitle(_ title: String, subTitle: String, for state: UIControlState) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.maximumLineHeight = 38
        
        let paragraph2 = NSMutableParagraphStyle()
        paragraph2.alignment = .center
        paragraph2.lineSpacing = 0
        paragraph2.maximumLineHeight = 8
        
        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: title + "\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 37.0),
                                                                               NSAttributedStringKey.paragraphStyle: paragraph,
                                                                               NSAttributedStringKey.foregroundColor : UIColor.white]))
        attString.append(NSAttributedString(string: subTitle, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 10.0, weight: .medium),
                                                                           NSAttributedStringKey.paragraphStyle: paragraph2,
                                                                           NSAttributedStringKey.foregroundColor : UIColor.white]))
        setAttributedTitle(attString, for: .normal)
        titleLabel?.numberOfLines = 2
        
        backgroundColor = defaultColor
        layer.cornerRadius = self.bounds.height/2
    }
    
    override func prepareForInterfaceBuilder() {
        setTitle("5", subTitle: "J K L", for: .normal)
    }
    
    // Highlight the buttons when tapping, just like the real thing.
    // Fun note: using the .allowUserInteraction option prevents the
    // same behavior as the Apple Calculator app 1+2+3 bug.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = self.highlightColor
        }, completion: nil)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = self.defaultColor
        }, completion: nil)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = self.defaultColor
        }, completion: nil)
    }
    
}
