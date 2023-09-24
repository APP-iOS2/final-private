//
//  UserStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI

final class UserStore: ObservableObject {
    @Published var user: [User] = []
    @Published var follower: [User] = []
    @Published var following: [User] = []
    
    init() {
        
    }
    
    static let user = User(
        name: "맛집탐방러",
        nickname: "Private",
        phoneNumber: "010-0000-0000",
        profileImageURL: "https://discord.com/channels/1087563203686445056/1153285554646036550/1154579593819344928",
        follower: [],
        following: [],
        myFeed: [],
        savedFeed: [],
        bookmark: [],
        chattingRoom: [],
        myReservation: []
    )
}

