//
//  PrivateIdentifiable.swift
//  Private
//
//  Created by 박범수 on 10/12/23.
//

import Foundation

protocol PrivateIdentifiable: Identifiable {
    var id: String { get }
}
