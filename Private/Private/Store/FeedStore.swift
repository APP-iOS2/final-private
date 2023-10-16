//
//  FeedStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FeedStore: ObservableObject {
    @Published var feedList: [MyFeed] = []

    private let dbRef = Firestore.firestore().collection("Feed")
    // UserStore 인스턴스를 저장하기 위한 속성 추가
    //private let userStore: UserStore
    init() {
        fetchFeeds()
    }
    func fetchFeeds() {
        dbRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            self?.feedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                var feed = MyFeed(documentData: data)
                feed?.createdAt = data["createdAt"] as? Double ?? 0.0 // createdAt 값을 Double로 설정
                return feed
            }
            .sorted(by: { Date(timeIntervalSince1970: $0.createdAt) > Date(timeIntervalSince1970: $1.createdAt) }) ?? []
        }
    }
    
    func isCurrentUserWriter(_ feed: MyFeed) -> Bool {
        return userStore.currentUserIsWriter(for: feed)
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
    
}

