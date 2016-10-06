//
//  ViewController.swift
//  CircularSpinnerExample
//
//  Created by Matteo Tagliafico on 19/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit
import CircularSpinner

class ViewController: UIViewController {
    
    // MARK: - properties
    private var containerView: UIView?
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }


    // MARK: - methods
    private func setupContainerView() {
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        containerView?.center = view.center
    }
    
    
    // MARK : - actions
    @IBAction private func showDeterminateSpinner(sender: UIButton?) {
        
        CircularSpinner.show(animated: true, showDismissButton: false, delegate: self)
        CircularSpinner.setValue(0.1, animated: true)
        
        delayWithSeconds(1) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.6, animated: true)
        }
        delayWithSeconds(2) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.3, animated: true)
        }
    }
    
    @IBAction private func showIndeterminateSpinner(sender: UIButton?) {
        
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        
        delayWithSeconds(5) {
            CircularSpinner.hide()
        }
    }
    
    @IBAction private func switchChangeValue(sender: UISwitch?) {
        if let sender = sender {
            if sender.isOn {
                view.addSubview(containerView!)
            } else {
                containerView?.removeFromSuperview()
            }
            CircularSpinner.useContainerView(sender.isOn ? containerView : nil)
        }
    }
}


// MARK: - CircularSpinnerDelegate
extension ViewController: CircularSpinnerDelegate {
    
    func circularSpinnerTitleForValue(_ value: Float) -> NSAttributedString {
        let attributeStr = NSMutableAttributedString(string: "\(Int(value * 100))%")
        attributeStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 70, weight: UIFontWeightThin)], range: NSMakeRange(0, attributeStr.string.characters.count - 1))
        attributeStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 50, weight: UIFontWeightUltraLight)], range: NSMakeRange(attributeStr.string.characters.count - 1, 1))
        return attributeStr
    }
}
