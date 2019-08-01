//
//  UIVIew+Shadows.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation
import UIKit

struct ShadowStyle {
    let opacity: Float
    let offset: CGFloat
    let radius: CGFloat
    
    var upsideDown: ShadowStyle {
        return ShadowStyle(opacity: opacity, offset: -offset, radius: radius)
    }
}

extension UIView {
    var shadowStyle: ShadowStyle {
        set {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = newValue.opacity
            self.layer.shadowOffset = CGSize(width: 0, height: newValue.offset)
            self.layer.shadowRadius = newValue.radius
        }
        get {
            return ShadowStyle(opacity: self.layer.shadowOpacity,
                               offset: self.layer.shadowOffset.height,
                               radius: self.layer.shadowRadius)
        }
    }
}
