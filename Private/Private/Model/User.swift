//
//  User.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct User: Hashable {
    let id: String = UUID().uuidString
    var name: String
    var nickname: String
    var phoneNumber: String
    var profileImageURL: String
    var follower: [String]
    var following: [String]
    var myFeed: [Feed]
    var savedFeed: [Feed]
    var bookmark: [Shop]
    var chattingRoom: [ChatRoom]
    var myReservation: [Reservation]
}
