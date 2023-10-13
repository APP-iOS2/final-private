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
    private let userRef = Firestore.firestore().collection("User")
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
        //        FollowStore.followingID(nickname: "yourNickname").getDocument { [weak self] (document, error) in
        //            if let error = error {
        //                print("Error fetching following list: \(error.localizedDescription)")
        //                return
        //            }
        //
        //            guard let document = document, document.exists,
        //                  let followingList = document.data()?["following"] as? [String] else {
        //                print("Cannot fetch following list")
        //                return
        //            }
        //
        //            self?.fetchFeeds(followingList: followingList)
        //        }
        let currentUserEmail = Auth.auth().currentUser?.email ?? ""
        userRef.document(currentUserEmail).collection("following").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error fetching following list: \(error.localizedDescription)")
                return
            }
            
            let followingList = snapshot?.documents.compactMap { $0.documentID } ?? []
            self?.fetchFeeds(followingList: followingList)
        }
    }
}

/*
 // 팔로잉-팔로워 부분 로직 테스트 중이므로 전체 피드를 불러오기
 
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
 */


