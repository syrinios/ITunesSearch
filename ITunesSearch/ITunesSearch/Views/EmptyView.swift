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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

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
        
        var title: String {
            switch self {
            case .search:
                return "Let's search!"
            case .noData:
                return "No data found!"
            case .error(let error):
                return "\(error.localizedDescription)"
            }
        }

        
        var description: String {
            switch self {
            case .search:
                return "Just write what do you have in your mind 😁"
            case .noData:
                return "Try with another term"
            default:
                return ""
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
        self.titleLabel.text = self.mode.title
        self.descriptionLabel.text = self.mode.description
    }

}
