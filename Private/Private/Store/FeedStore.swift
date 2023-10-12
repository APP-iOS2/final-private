//
//  FeedStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FeedStore: ObservableObject {
    @Published var feedList: [MyFeed] = []
    
    private let dbRef = Firestore.firestore().collection("Feed")
    private var followStore = FollowStore()
    
    
    init() {
        fetchFollowingFeeds()
    }
    
    func fetchFeeds(followingList: [String]) {
        dbRef.whereField("writerNickname", in: followingList).addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching feeds: \(error.localizedDescription)")
                return
            }
            
            self?.feedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
        }
    }
    // Feed 객체를 Firestore 데이터로 변환하는 함수입니다.
    private func makeFeedData(from feed: MyFeed) -> [String: Any] {
        return [
            "writerNickname": feed.writerNickname,
            "writerName": feed.writerName,
            "writerProfileImage": feed.writerProfileImage,
            "images": feed.images,
            "contents": feed.contents,
            "createdAt": Timestamp(date: Date(timeIntervalSince1970: feed.createdAt)),
            "title": feed.title,
            "category": feed.category,
            "address": feed.address,
            "roadAddress": feed.roadAddress,
            "mapx": feed.mapx,
            "mapy": feed.mapy,
            
            
        ]
    }
    func fetchFollowingFeeds() {
        FollowStore.followingID(nickname: "yourNickname").getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching following list: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let followingList = document.data()?["following"] as? [String] else {
                print("Cannot fetch following list")
                return
            }
            
            self?.fetchFeeds(followingList: followingList)
        }
    }
}

