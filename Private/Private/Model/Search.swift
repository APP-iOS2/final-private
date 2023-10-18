//
//  Search.swift
//  Private
//
//  Created by 변상우 on 10/10/23.
//

import Foundation
import NMapsMap

struct SearchResultList: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [SearchResult]
}

struct SearchResult: Codable, Hashable {
    let title: String
    let category: String
    let address: String
    let roadAddress: String
    let mapx: String
    let mapy: String
}

struct ReverseGeoCodingResult: Codable {
    let status: Status
    let results: [GeoCodingResult]
}

struct GeoCodingResult: Codable {
    let name: String
    let code: Code
    let region: Region
}

struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

struct Region: Codable {
    let area0, area1, area2, area3: Area
    let area4: Area
}

struct Area: Codable {
    let name: String
    let coords: Coords
}

struct Coords: Codable {
    let center: Center
}

struct Center: Codable {
    let crs: String
    let x, y: Double
}

struct Status: Codable {
    let code: Int
    let name, message: String
}
