//
//  Search.swift
//  Private
//
//  Created by 변상우 on 10/10/23.
//

import Foundation

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
