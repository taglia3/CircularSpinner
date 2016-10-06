//
//  Utils.swift
//  CircularSpinnerExample
//
//  Created by Matteo Tagliafico on 15/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import Foundation

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { 
        completion()
    }
}
