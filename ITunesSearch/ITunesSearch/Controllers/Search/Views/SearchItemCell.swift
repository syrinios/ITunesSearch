//
//  SearchItemCell.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import UIKit
import Reusable

class SearchItemCell: UITableViewCell, NibReusable {
    var item: SearchItem? { didSet { self.reload() }}

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLAbel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        kindLabel.font = AppStyle.fonts.semibold15
        trackNameLabel.font = AppStyle.fonts.bold15
        artistNameLabel.font = AppStyle.fonts.regular15
        durationLabel.font = AppStyle.fonts.regular13
        dateLabel.font = AppStyle.fonts.regular13
        priceLAbel.font = AppStyle.fonts.regular13

        contentView.backgroundColor = AppStyle.colors.ghostWhite
        shadowView.shadowStyle = AppStyle.shadows.smallLight
        shadowView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func reload() {
        if UserDefaults.standard.bool(forKey: item!.id) {
            shadowView.backgroundColor = AppStyle.colors.congressBlue.withAlphaComponent(0.3)
        } else {
            shadowView.backgroundColor = .white
        }

        previewImageView.sfSetImage(with: item?.thumbnailUrl, placeholder: #imageLiteral(resourceName: "placeholder"))
        kindLabel.text = item?.kind?.firstUppercased.replacingOccurrences(of: "-", with: " ") ?? "Kind undefined"
        trackNameLabel.text = item?.trackName ?? ""
        artistNameLabel.text = item?.artistName ?? ""
        if let trackTimeMillis = item?.trackTimeMillis, trackTimeMillis > 0 {
            durationLabel.text = "\(trackTimeMillis.milliSecondsToHoursMinutuesSeconds())"
        } else {
           durationLabel.text = ""
        }
        if let releaseDate = item?.releaseDate {
            dateLabel.text = "Released in \(DateFormatter.year.string(from: releaseDate))"
        } else {
            dateLabel.text = ""
        }
        if let price = item?.trackPrice, let currency = item?.currency {
            priceLAbel.text = "\(price) \(currency)"
        } else {
            priceLAbel.text = ""
        }
    }
}
