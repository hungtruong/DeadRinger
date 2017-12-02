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
    let numberFontSize = 37.0
    let letterFontSize = 10.0
    
    @IBInspectable var coolString: String = "2 A B C" {
        didSet {
            setTitle("5", subTitle: "A B C", for: .normal)
        }
    }
    

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
        
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        layer.cornerRadius = self.bounds.height/2
    }
    
    override func prepareForInterfaceBuilder() {
        setTitle("5", subTitle: "J K L", for: .normal)
    }
    
}
