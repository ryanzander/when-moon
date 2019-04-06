//
//  RoundView.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/25/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class RoundView: UIControl {

    let cornerRadius: CGFloat =  8.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }

}
