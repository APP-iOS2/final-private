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
//uploadToast
//


final class FeedStore: ObservableObject {
    
 
    var db = Firestore.firestore()
    var storage = Storage.storage()
    // @Published 는 SwiftUI에서 ObservableObject의 프로퍼티가 변경될 때 View를 업데이트하도록 합니다.
    @Published var feedList: [MyFeed] = []
    @Published var uploadToast: Bool = false
    @Published var isPostViewPresented: Bool = false

    var selctedFeed = MyFeed()
    // Firestore 데이터베이스의 "Feed" 컬렉션에 대한 참조를 생성합니다.
    private let feedRef = Firestore.firestore().collection("Feed")
    
    // 초기화 함수에서 피드를 가져옵니다.
    init() {
        fetchFeeds()
    }
    //MARK: 피드 패치
    func fetchFeeds() {
                print("File: \(#file), Line: \(#line), Function: \(#function), Column: \(#column),","피드패치중")
        // Firestore에서 실시간으로 데이터를 가져오기 위해 addSnapshotListener를 사용합니다.
        feedRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            // 에러가 있다면 콘솔에 출력하고 반환합니다.
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            self?.feedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let documetID = queryDocumentSnapshot.documentID
                let data = queryDocumentSnapshot.data()
                var feed = MyFeed(documentData: data)
                feed?.id = documetID
                feed?.createdAt = data["createdAt"] as? Double ?? 0.0 // createdAt 값을 Double로 설정
                return feed
            }
            .sorted(by: { Date(timeIntervalSince1970: $0.createdAt) > Date(timeIntervalSince1970: $1.createdAt) }) ?? []
        }
    }
//    func fetchFollowingFeeds() {
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
//    }
    //MARK: 피드 추가
    func addFeed(_ feed: MyFeed) {
        feedRef.document(feed.id).collection("Feed")
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
            self.uploadToast = true
    }
    
    // Feed 객체를 Firestore 데이터로 변환하는 함수입니다.
    //MARK: 피드 firebase데이터 변환
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
    //MARK: 피드 삭제
    /*
    func deleteFeed(writerNickname: String) {
        //Firestore.firestore().collection("Feed")
        let feedRef = feedRef.document(Feed.writerNickname).delete() { error in
            if let error = error {
                print("Error deleting feed from Firebase: \(error.localizedDescription)")
            } else {
                print("Feed deleted from Firebase successfully")
            }
        }
    }
     */
    /// 일단 주석해두었습니다
//    //MARK: 해당 닉을 가진 사람의 게시글 전체  삭제
//    func deleteFeed(writerNickname: String) {
//        // Firestore.firestore().collection("Feed")
//        let query = feedRef.whereField("id", isEqualTo: writerNickname)
//        
//        query.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error deleting feed from Firebase: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else {
//                print("No documents found.")
//                return
//            }
//            
//            for document in documents {
//                // 해당 문서를 삭제
//                document.reference.delete { error in
//                    if let error = error {
//                        print("Error deleting feed from Firebase: \(error.localizedDescription)")
//                    } else {
//                        print("Feed deleted from Firebase successfully")
//                        self.fetchFeeds()
//                    }
//                }
//            }
//        }
//    }
    
    
    
    //MARK: 해당 피드id 값을 읽어 그것만 삭제
    func deleteFeed(feedId: String) {
        print("Function: \(#function) started")
        print("File: \(#file), Line: \(#line), Function: \(#function)")
        
        let query = feedRef.whereField("id", isEqualTo: feedId)
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error deleting feed from Firebase: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            for document in documents {
                // 해당 문서를 삭제
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting feed from Firebase: \(error.localizedDescription)")
                    } else {
                        print("Feed deleted from Firebase successfully")
                        self.fetchFeeds()
                    }
                }
            }
        }
    }
}
