//
//  EmptyView.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    enum Mode {
        case search
        case noData
        case error(Error)
        
        var image: UIImage {
            switch self {
            case .search:
                return #imageLiteral(resourceName: "search")
            case .noData:
                return #imageLiteral(resourceName: "no_data")
            default:
                return #imageLiteral(resourceName: "error")
            }
        }
        
        var description: String {
            switch self {
            case .search:
                return "Let's search!\nJust write what do you have in your mind 😁"
            case .noData:
                return "No data found!\nTry with another term"
            case .error(let error):
                return "\(error.localizedDescription)"
            }
        }
    }
    
    var mode: Mode = .noData {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        self.imageView.image = self.mode.image
        self.label.text = self.mode.description
    }

}
