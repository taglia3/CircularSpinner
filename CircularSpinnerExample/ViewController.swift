//
//  ViewController.swift
//  CircularSpinnerExample
//
//  Created by Matteo Tagliafico on 19/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK : - actions
    @IBAction private func showDeterminateSpinner(sender: UIButton?) {
        
        CircularSpinner.show(animated: true, delegate: self)
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
}


// MARK: - CircularSpinnerDelegate
extension ViewController: CircularSpinnerDelegate {
    
    func circularSpinnerTitleForValue(value: Float) -> NSAttributedString {
        let attributeStr = NSMutableAttributedString(string: "\(Int(value * 100))%")
        attributeStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(70, weight: UIFontWeightThin)], range: NSMakeRange(0, attributeStr.string.characters.count - 1))
        attributeStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(50, weight: UIFontWeightUltraLight)], range: NSMakeRange(attributeStr.string.characters.count - 1, 1))
        return attributeStr
    }
}
