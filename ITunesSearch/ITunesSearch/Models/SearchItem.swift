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

    static let allValues = [movie, podcast, music, musicVideo, audiobook,
                            shortFilm, tvShow, software, ebook, all]//.map({ $0.mediaName })
    
    var mediaName: String {
        return String(describing: self)
    }
    
    public static func == (rhs: Media?, lhs: Media) -> Bool {
        return rhs?.mediaName.elementsEqual(lhs.mediaName) ?? false
    }
}

struct MediaCache {
    static let key = Constants.filters
    static func save(_ value: Media) {
        UserDefaults.standard.set(value.rawValue, forKey: key)
        UserDefaults.standard.synchronize()
    }
    static func get() -> Media? {
        guard let rawValue  = UserDefaults.standard.string(forKey: key) else { return nil }
        return Media(rawValue: rawValue)    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
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
    let thumbnailUrl: URL?
    let trackViewUrl: URL?
    let collectionPrice: Double?
    let trackPrice: Double?
    let currency: String
    let releaseDate: Date?
    let country: String?
    let trackNumber: Int?
    let trackCount: Int?
    let trackTimeMillis: Int?
    
    var id: String {
        return "\(trackName ?? "")\(artistId ?? 0)\(collectionId ?? 0)\(trackId ?? 0)"
    }
    
    enum CodingKeys: String, CodingKey {
        case artistId
        case collectionId
        case trackId
        case kind
        case artistName
        case collectionName
        case trackName
        case artistViewUrl
        case thumbnailUrl = "artworkUrl100"
        case trackViewUrl
        case collectionPrice
        case trackPrice
        case currency
        case releaseDate
        case country
        case trackNumber
        case trackCount
        case trackTimeMillis
    }
}
