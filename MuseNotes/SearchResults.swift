//
//  SearchResult.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 12/8/22.
//

import Foundation

struct SearchResults: Codable {
    let tracks: TrackResults
}

struct TrackResults: Codable {
    let items: [Track]
}

struct Track: Codable {
    let album: Album
    let artists: [Artist]
//    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
}

struct Album: Codable {
    let album_type: String
    let artists: [Artist]
//    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
//    let label: String
    let name: String
}

struct APIImage: Codable {
    let url: String
}

struct Artist: Codable {
    let name: String
}
