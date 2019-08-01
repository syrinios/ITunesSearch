//
//  Int+Utils.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

extension Int {
    func milliSecondsToHoursMinutuesSeconds() -> String {
        let seconds = self / 1000
        let hh = (seconds / 3600) > 0 ? "\(seconds / 3600)" : ""
        let mm = ((seconds % 3600) / 60 ) > 0 ? "\((seconds % 3600) / 60 ):" : "00:"
        let ss = ((seconds % 3600) % 60 ) > 0 ? "\((seconds % 3600) % 60 ):" : "00"
        return "\(hh)\(mm)\(ss)"
    }
}
