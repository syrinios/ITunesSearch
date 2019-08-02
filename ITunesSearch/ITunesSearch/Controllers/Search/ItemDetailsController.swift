//
//  ItemDetailsController.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/2/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyAttributes

class ItemDetailsController: UIViewController {
    @IBOutlet weak var infosView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var item: SearchItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infosView.layer.cornerRadius = 16
        infosView.layer.masksToBounds = true
        
        thumbnailImageView.sfSetImage(with: item?.thumbnailUrl, placeholder: #imageLiteral(resourceName: "placeholder"))
        kindLabel.text = item?.kind?.firstUppercased.replacingOccurrences(of: "-", with: " ") ?? "Kind undefined"
        setText(to: collectionNameLabel, with: item?.collectionName, with: "Collection name")
        setText(to: artistNameLabel, with: item?.artistName, with: "Artist name")
        setText(to: trackNameLabel, with: item?.trackName, with: "Track name")
        if let trackCount = item?.trackCount, let trackNumber = item?.trackNumber {
            setText(to: trackNumberLabel, with: "\(trackNumber)/\(trackCount)", with: "Track ", checkField: false)
        }
        if let price = item?.trackPrice, let currency = item?.currency {
            setText(to: priceLabel, with: "\(price) \(currency)", with: "Track price: ", checkField: false)
        }
        var countryString = ""
        if let country = item?.country, !country.elementsEqual("") {
            countryString = "\(country), "
        }
        if let releaseDate = item?.releaseDate {
            setText(to: releaseDateLabel, with: "\(countryString)\(DateFormatter.year.string(from: releaseDate))", with: "Released in", checkField: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    private func setText(to label: UILabel, with itemField: String?, with description: String, checkField: Bool = true) {
        if checkField, let field = itemField, !field.elementsEqual("") {
            label.attributedText =  "\(description): ".withFont(AppStyle.fonts.bold15) + "\(field)".withFont(AppStyle.fonts.regular15)
        } else if let field = itemField, !field.elementsEqual("") {
            label.attributedText =  "\(description): ".withFont(AppStyle.fonts.bold15) + "\(field)".withFont(AppStyle.fonts.regular15)
        } else {
            label.text = ""
        }
    }
}
