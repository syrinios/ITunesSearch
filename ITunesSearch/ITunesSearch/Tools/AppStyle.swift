//
//  AppStyle.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation
import UIKit

struct AppStyle {
    
    struct Fonts {
        let regular13 = Fonts.appFont(ofSize: 13, weight: UIFont.Weight.regular)
        let regular15 = Fonts.appFont(ofSize: 15, weight: UIFont.Weight.regular)
        let regular17 = Fonts.appFont(ofSize: 17, weight: UIFont.Weight.regular)
        
        let medium13 = Fonts.appFont(ofSize: 13, weight: UIFont.Weight.medium)
        
        let semibold15 = Fonts.appFont(ofSize: 15, weight: UIFont.Weight.semibold)
        let semibold17 = Fonts.appFont(ofSize: 17, weight: UIFont.Weight.semibold)
        
        let bold15 = Fonts.appFont(ofSize: 15, weight: UIFont.Weight.bold)
        
        private static func appFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
            return UIFont.systemFont(ofSize: ofSize, weight: weight)
        }
    }
    
    struct Colors {
        // shadows of gray
        let ghostWhite = UIColor(hex: 0xF5F5F6)
    }
    
    struct Shadows {
        let black = ShadowStyle(opacity: 0.4, offset: 0, radius: 8)
        let big = ShadowStyle(opacity: 0.1, offset: 3, radius: 7)
        let smallDark = ShadowStyle(opacity: 0.2, offset: 3, radius: 3)
        let smallLight = ShadowStyle(opacity: 0.1, offset: 2, radius: 4)
        let none = ShadowStyle(opacity: 0, offset: 0, radius: 0)
    }
    
    static let colors = Colors()
    static let fonts = Fonts()
    static let shadows = Shadows()
}
