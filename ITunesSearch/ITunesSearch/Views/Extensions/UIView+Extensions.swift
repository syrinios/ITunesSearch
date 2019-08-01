//
//  UIView+Extensions.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func fromNib<T: UIView>() -> T {
        return self.fromNib(fileOwner: nil)
    }
    
    static func fromNib<T: UIView>(fileOwner: Any?) -> T {
        let className = String(describing: self)
        guard let instance = UINib(nibName: className, bundle: nil).instantiate(withOwner: fileOwner, options: nil).first as? UIView else {
            // If this happens, it means the xcodeproj is broken
            fatalError("Can't initialize view from nib \(String(describing: self))")
        }
        guard let customInstance = instance as? T else {
            fatalError("Can't cast view from nib \(String(describing: self))")
        }
        return customInstance
    }
}
