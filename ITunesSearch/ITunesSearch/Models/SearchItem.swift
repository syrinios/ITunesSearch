//
//  SearchItem.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

enum Media: String, Codable {
    case movie
    case podcast
    case music
    case musicVideo
    case audiobook
    case shortFilm
    case tvShow
    case software
    case ebook
    case all
    
    var mediaName: String {
        return String(describing: self)
    }
}

struct SearchResult: Codable {
    let resultCount: Int
    let results: [SearchItem]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

struct SearchItem: Codable {
    let kind: String?
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artistViewUrl: URL?
    let previewUrl: URL?
    let trackViewUrl: URL?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: Date?
    let country: String?
    let trackNumber: Int?
    let trackCount: Int?
    let trackTimeMillis: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case artistId
        case collectionId
        case trackId
        case kind
        case artistName
        case collectionName
        case trackName
        case artistViewUrl
        case previewUrl
        case trackViewUrl
        case collectionPrice
        case trackPrice
        case releaseDate
        case country
        case trackNumber
        case trackCount
        case trackTimeMillis
    }
}
