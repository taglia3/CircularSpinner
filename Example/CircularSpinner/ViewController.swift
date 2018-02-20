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
    @IBOutlet private var containerView: UIView!
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize spinner (globally)
//        CircularSpinner.trackPgColor = UIColor.orange
//        CircularSpinner.trackBgColor = UIColor.green
        CircularSpinner.dismissButton = true
    }
    
    
    // MARK : - actions
    @IBAction private func showDeterminateSpinner(sender: UIButton?) {
        
        //
        CircularSpinner.show(animated: true, showDismissButton: true, delegate: self)
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
//            CircularSpinner.hide()
        }
    }
    
    @IBAction private func switchChangeValue(sender: UISwitch?) {
        if let sender = sender {
            CircularSpinner.useContainerView(sender.isOn ? containerView : nil)
        }
    }
}


// MARK: - CircularSpinnerDelegate
extension ViewController: CircularSpinnerDelegate {
    
    func circularSpinnerTitleForValue(_ value: Float) -> NSAttributedString {
        let attributeStr = NSMutableAttributedString(string: "\(Int(value * 100))%")
        if #available(iOS 8.2, *) {
            attributeStr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.thin)], range: NSMakeRange(0, attributeStr.string.count - 1))
            attributeStr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.ultraLight)], range: NSMakeRange(attributeStr.string.count - 1, 1))
        } else {
            attributeStr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 60)], range: NSMakeRange(0, attributeStr.string.count - 1))
            attributeStr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40)], range: NSMakeRange(attributeStr.string.count - 1, 1))
        }
        return attributeStr
    }
}
