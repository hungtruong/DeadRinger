//
//  KeypadView.swift
//  iPhoneXLockScreen
//
//  Created by Hung Truong on 12/2/17.
//  Copyright © 2017 Hung Truong. All rights reserved.
//

import UIKit

protocol KeypadViewDelegate : NSObjectProtocol {
    func keypadButtonPressed(_ value: String)
}

class KeypadView: UIView {
    weak var delegate : KeypadViewDelegate?
    @IBOutlet var oneButton: KeypadButton!
    @IBOutlet var twoButton: KeypadButton!
    @IBOutlet var threeButton: KeypadButton!
    @IBOutlet var fourButton: KeypadButton!
    @IBOutlet var fiveButton: KeypadButton!
    @IBOutlet var sixButton: KeypadButton!
    @IBOutlet var sevenButton: KeypadButton!
    @IBOutlet var eightButton: KeypadButton!
    @IBOutlet var nineButton: KeypadButton!
    @IBOutlet var zeroButton: KeypadButton!
    
    override func awakeFromNib() {
        oneButton.setTitle("1", subTitle: "     ", for: .normal)
        twoButton.setTitle("2", subTitle: "A B C", for: .normal)
        threeButton.setTitle("3", subTitle: "D E F", for: .normal)
        fourButton.setTitle("4", subTitle: "G H I", for: .normal)
        fiveButton.setTitle("5", subTitle: "J K L", for: .normal)
        sixButton.setTitle("6", subTitle: "M N O", for: .normal)
        sevenButton.setTitle("7", subTitle: "P Q R S", for: .normal)
        eightButton.setTitle("8", subTitle: "T U V", for: .normal)
        nineButton.setTitle("9", subTitle: "W X Y Z", for: .normal)
        zeroButton.setTitle("0", subTitle: "     ", for: .normal)
    }
    
    @IBAction func keypadButtonPressed(_ button: KeypadButton) {
        switch button {
        case oneButton:
            delegate?.keypadButtonPressed("1")
        case twoButton:
            delegate?.keypadButtonPressed("2")
        case threeButton:
            delegate?.keypadButtonPressed("3")
        case fourButton:
            delegate?.keypadButtonPressed("4")
        case fiveButton:
            delegate?.keypadButtonPressed("5")
        case sixButton:
            delegate?.keypadButtonPressed("6")
        case sevenButton:
            delegate?.keypadButtonPressed("7")
        case eightButton:
            delegate?.keypadButtonPressed("8")
        case nineButton:
            delegate?.keypadButtonPressed("9")
        case zeroButton:
            delegate?.keypadButtonPressed("0")
        default:
            assertionFailure("this really shouldn't happen")
        }
    }
}
