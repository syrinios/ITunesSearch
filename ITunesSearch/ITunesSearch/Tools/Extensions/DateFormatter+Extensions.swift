//
//  DateFormatter+Extensions.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
    
    convenience init(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
    
    @nonobjc static let dmyFormatter = DateFormatter(format: "dd/MM/yyyy")
    @nonobjc static let isoDate = DateFormatter(format: "yyyy-MM-dd")
    @nonobjc static let fullDate = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
