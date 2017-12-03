//
//  ViewController.swift
//  iPhoneXLockScreen
//
//  Created by Hung Truong on 11/29/17.
//  Copyright © 2017 Hung Truong. All rights reserved.
//

import UIKit
import CoreMotion

enum PasscodeViewMode {
    case inactive
    case lockedScreen
    case passcodeEntry
}

class ViewController: UIViewController {
    var passcodeViewMode: PasscodeViewMode = .inactive
    
    @IBOutlet var inactiveView: UIView!
    
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
    
    @IBOutlet var darkBlurView: UIVisualEffectView!
    @IBOutlet var enterPasscodeLabel: UILabel!
    @IBOutlet var passcodeDetailLabel: UILabel!
    @IBOutlet var passcodeDotsView: PasscodeDotsView!
    @IBOutlet var passcodeKeypadView: KeypadView!
    @IBOutlet var emergencyButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var tiltActionTimer : Timer?
    
    var passcodeText : String = "" {
        didSet {
            if oldValue.count < passcodeText.count {
                passcodeDotsView.toggleDot(index: passcodeText.count - 1, filled: true)
            } else {
                passcodeDotsView.toggleDot(index: oldValue.count - 1, filled: false)
            }
            
            if passcodeText.count == 6 {
                let message = "Your passcode is \(passcodeText)"
                let alert = UIAlertController(title: "Bro you got played", message: message, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okayAction)

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var motionManager: CMMotionManager = CMMotionManager()
    
    func lockedScreenViewsGroup() -> [UIView] {
        return [timeLabel, dateLabel, flashlightButton, cameraButton]
    }
    
    func passcodeEntryViewsGroup() -> [UIView] {
        return [darkBlurView, enterPasscodeLabel, passcodeDetailLabel, passcodeDotsView, passcodeKeypadView, emergencyButton, cancelButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeAndDate()
        
        // In case the minute or date changes
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            self.setTimeAndDate()
        }
        
        // Edge gesture recognizer to recreate the swipe up to unlock. The gesture just shows the keypad view.
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(handlePan(_:)))
        edgeSwipeGestureRecognizer.edges = .bottom
        edgeSwipeGestureRecognizer.isEnabled = true
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        
        initialViewSetup()
        passcodeKeypadView.delegate = self
        
        // Prevent the phone from sleeping
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Set up a motion manager to reproduce the "raise to wake" functionality
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { (motion, error) in
            guard let motion = motion else { return }
            self.handleDeviceMotion(motion: motion)
            }
        
    }
    
    /// This method will start a timer to either "wake" the device or put it to sleep if it is in the right orientation.
    /// On a timer because the real device seems to delay it by a bit.
    func handleDeviceMotion(motion: CMDeviceMotion) {
        // device is tilted up
        if motion.attitude.pitch > 0.5 {
            if tiltActionTimer == nil {
                tiltActionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                    if self.passcodeViewMode == .inactive {
                        self.setPasscodeViewMode(.lockedScreen)
                    }
                    self.tiltActionTimer = nil
                })
            }

        } else { //device is tilted down
            if passcodeViewMode == .lockedScreen {
                //delay switching to inactive mode for a sec
                if tiltActionTimer == nil {
                    tiltActionTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { (_) in
                        if self.passcodeViewMode == .lockedScreen { //we could've gone to the passcode entry at this point
                            self.setPasscodeViewMode(.inactive)
                        }
                        self.tiltActionTimer = nil
                    })
                }
            }
        }
    }
    
    /// Make sure views are in the right state
    func initialViewSetup() {
        for view in self.passcodeEntryViewsGroup() {
            view.alpha = 0.0
        }
        
        for view in self.lockedScreenViewsGroup() {
            view.alpha = 1.0
        }
        inactiveView.alpha = 1.0
    }
    
    /// Handles state transitions between inactive (black screen), locked screen (clock, date, flashlight, other stuff) and the passcode entry modes
    func setPasscodeViewMode(_ mode: PasscodeViewMode) {
        // if we change state then just invalidate the tilt timer
        tiltActionTimer?.invalidate()
        tiltActionTimer = nil
        
        guard passcodeViewMode != mode else { return }
        let previousMode = passcodeViewMode
        passcodeViewMode = mode
        
        setNeedsStatusBarAppearanceUpdate()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        
        switch mode {
        // If we're switching to inactive, make the black screen appear
        case .inactive:
            UIView.animate(withDuration: 0.2, animations: {
                self.inactiveView.alpha = 1.0
            })
           
        
        case .lockedScreen:
            // if we came from the passcode entry view, animate it out, otherwise we're coming from the dark view so animate that one out
            if previousMode == .passcodeEntry {
                UIView.animate(withDuration: 0.2, animations: {
                    for view in self.passcodeEntryViewsGroup() {
                        view.alpha = 0.0
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.inactiveView.alpha = 0.0
                })
            }
            
            // If we're coming from the inactive mode, set a timer to show the passcode mode
            if previousMode == .inactive {
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
                    self.setPasscodeViewMode(.passcodeEntry)
                })
            }
            
        // Play the haptic feedback sound and animate the passcode entry views in
        case .passcodeEntry:
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.error)
            UIView.animate(withDuration: 0.2, animations: {
                for view in self.passcodeEntryViewsGroup() {
                    view.alpha = 1.0
                }
            })
        }
    }
    
    /// Lets the user get to the passcode entry state by tapping the locked screen
    @IBAction func lockedScreenBackgroundTapped(_ sender: Any) {
        setPasscodeViewMode(.passcodeEntry)
    }
    
    /// Lets the user get out of the asleep state by tapping
    @IBAction func inactiveScreenTapped(_ sender: Any) {
        setPasscodeViewMode(.lockedScreen)
    }
    
    // MARK: status bar and home indicator stuff
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // hide the status bar on the "sleep" screen
    override var prefersStatusBarHidden: Bool {
        switch passcodeViewMode {
        case .inactive:
            return true
        default:
            return false
        }
    }
    
    // Hides the home indicator on the inactive and passcode entry view
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        switch passcodeViewMode {
        case .inactive, .passcodeEntry:
            return true
        default:
            return false
        }
    }
    
    /// Prevents the user from swiping up to dismiss the app.
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return UIRectEdge.bottom
    }
    
    // handle the swipe up from the bottom of the screen
    @objc func handlePan(_ sender: Any) {
        if passcodeViewMode == .lockedScreen {
            setPasscodeViewMode(.passcodeEntry)
        }
    }
    
    // Calculates the date and time for the lock sceen labels
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
    
    // Deletes the last pressed entry or goes back to the lock screen
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if passcodeText.count == 0 {
            setPasscodeViewMode(.lockedScreen)
        } else {
            passcodeText.remove(at: passcodeText.index(before: passcodeText.endIndex))
        }
    }
}

// Handles the keyboard view's delegate methods
extension ViewController : KeypadViewDelegate {
    func keypadButtonPressed(_ value: String) {
        guard passcodeText.count < 6 else { return }
        passcodeText.append(contentsOf: value)
    }
}




















