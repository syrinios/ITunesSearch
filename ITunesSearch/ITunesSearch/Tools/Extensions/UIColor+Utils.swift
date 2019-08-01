//
//  UIColor+Utils.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Create color with values O..255
    ///
    /// - Parameters:
    ///   - red: red value
    ///   - green: green value
    ///   - blue: blue value
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    
    /// Create color from hex value: 0xRRGGBB
    ///
    /// - Parameter hex: hex value
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: (hex) & 0xFF)
    }
}

