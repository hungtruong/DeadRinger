//
//  ViewController.swift
//  iPhoneXLockScreen
//
//  Created by Hung Truong on 11/29/17.
//  Copyright © 2017 Hung Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var flashlightButton: UIButton! {
        didSet {
            flashlightButton.layer.cornerRadius = flashlightButton.frame.height/2
        }
    }
    @IBOutlet var cameraButton: UIButton! {
        didSet {
            cameraButton.layer.cornerRadius = cameraButton.frame.height/2
        }
    }
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeAndDate()
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(handlePan(_:)))
        edgeSwipeGestureRecognizer.edges = .bottom
        edgeSwipeGestureRecognizer.isEnabled = true
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Prevents the user from swiping up to dismiss the app.
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return UIRectEdge.bottom
    }
    
    @objc func handlePan(_ sender: Any) {
        print("Pan")
    }
    
    func setTimeAndDate() {
        // short time style still has AM/PM so just get the first chunk
        let time = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        .components(separatedBy: .whitespaces)
        .first
        timeLabel.text = time
        
        // There aren't any DateFormatter.Styles that match what the lock screen shows so this is hardcoded :(
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d") // set template after setting locale
        dateLabel.text = dateFormatter.string(from: Date())
    }
}






















