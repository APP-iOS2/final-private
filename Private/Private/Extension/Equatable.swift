//
//  Equatable.swift
//  Private
//
//  Created by 박범수 on 10/20/23.
//

import Foundation

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
