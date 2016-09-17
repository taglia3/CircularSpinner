//
//  ViewController.swift
//  CircularSpinnerExample
//
//  Created by Matteo Tagliafico on 15/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delayWithSeconds(1) {
            CircularSpinner.show("Ciao", animated: true, type: .determinate, delegate: self)
            CircularSpinner.sharedInstance.type = .indeterminate
        }
        
        delayWithSeconds(1) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.1, animated: true)
        }
        delayWithSeconds(2) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.1, animated: true)
        }
        delayWithSeconds(3) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.3, animated: true)
        }
        delayWithSeconds(4) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.4, animated: true)
        }
        delayWithSeconds(5) {
            CircularSpinner.setValue(CircularSpinner.sharedInstance.value + 0.1, animated: true)
        }
    }
}


// MARK: - CircularSpinnerDelegate
extension ViewController: CircularSpinnerDelegate {
    
    func circularSpinnerTitleForValue(value: Float) -> NSAttributedString {
        
        let attributeStr = NSMutableAttributedString(string: "\(Int(value * 100))%")
        attributeStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(60, weight: UIFontWeightThin)], range: NSMakeRange(0, attributeStr.string.characters.count - 1))
        attributeStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(40, weight: UIFontWeightUltraLight)], range: NSMakeRange(attributeStr.string.characters.count - 1, 1))
        return attributeStr
    }
}

