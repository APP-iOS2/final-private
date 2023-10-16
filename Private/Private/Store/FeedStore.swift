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
    
    // @Published 는 SwiftUI에서 ObservableObject의 프로퍼티가 변경될 때 View를 업데이트하도록 합니다.
    @Published var feedList: [MyFeed] = []
    
    // Firestore 데이터베이스의 "Feed" 컬렉션에 대한 참조를 생성합니다.
    private let dbRef = Firestore.firestore().collection("Feed")
    
    // 초기화 함수에서 피드를 가져옵니다.
    init() {
        fetchFeeds()
    }
    // 피드를 Firestore에서 가져오는 함수입니다.
    func fetchFeeds() {
        // Firestore에서 실시간으로 데이터를 가져오기 위해 addSnapshotListener를 사용합니다.
        dbRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            // 에러가 있다면 콘솔에 출력하고 반환합니다.
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            // 문서 데이터를 Feed 타입으로 변환하고 feedList를 업데이트합니다.
            self?.feedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []  // 문서가 없다면 빈 배열을 할당합니다.
        }
    }
    
    func addFeed(_ feed: MyFeed) {
        dbRef.document(feed.id).collection("Feed")
            .document(feed.id)
            .setData(["writerNickname": feed.writerNickname,
                      "writerName": feed.writerName,
                      "writerProfileImage": feed.writerProfileImage,
                      "images": feed.images,
                      "contents": feed.contents,
                      "createdAt": feed.createdAt,
                      "title": feed.title,
                      "category": feed.category,
                      "address": feed.address,
                      "roadAddress": feed.roadAddress,
                      "mapx": feed.mapx,
                      "mapy": feed.mapy,
                     ])
        
        
//        fetchFeed()
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

