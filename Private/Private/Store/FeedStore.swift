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

import GoogleSignIn


final class FeedStore: ObservableObject {
    
    // @Published 는 SwiftUI에서 ObservableObject의 프로퍼티가 변경될 때 View를 업데이트하도록 합니다.
    @Published var feedList: [MyFeed] = []
    
    let userStore: UserStore = UserStore()
    // Firestore 데이터베이스의 "Feed" 컬렉션에 대한 참조를 생성합니다.
    private let dbRef = Firestore.firestore().collection("Feed")
    
    // 초기화 함수에서 피드를 가져옵니다.
    init() {
        fetchFeeds()
    }
    
    //MARK: 피드 패치
    // 피드를 Firestore에서 가져오는 함수입니다.
    func fetchFeeds() {
        // Firestore에서 실시간으로 데이터를 가져오기 위해 addSnapshotListener를 사용합니다.
        dbRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            // 에러가 있다면 콘솔에 출력하고 반환합니다.
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
    //MARK: 피드 추가
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
    }
    //MARK: 피드 삭제
    func deleteFeed(_ feed: MyFeed) {
        let feedRef = dbRef.document(feed.id)
        
        // 해당 피드를 Firestore에서 삭제
        feedRef.delete { error in
            if let error = error {
                print("Error deleting feed: \(error.localizedDescription)")
            } else {
                print("Feed deleted successfully")
            }
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
    
    
}
//    func isCurrentUserWriter(feed: MyFeed, completion: @escaping (Bool) -> Void) {
//        AuthViewModel.shared.userSession?.getCurrentUserNickname { currentUserNickname in
//            if let currentUserNickname = currentUserNickname {
//                let writerNickname = feed.writerNickname
//                let isWriter = writerNickname == currentUserNickname
//                completion(isWriter)
//            } else {
//                completion(false) // 사용자가 로그인되어 있지 않은 경우
//            }
//        }
//    }

//    // 작성자 닉네임과 현재 사용자의 닉네임이 같은지 확인하는 함수
//    //var isCurrentUser: Bool { return AuthStore.shared.userSession?.uid == id}
//    func isCurrentUserAuthor(feed: MyFeed, completion: @escaping (Bool) -> Void) {
//        AuthStore.shared.doubleCheckNickname { currentUserNickname in
//            if let currentUserNickname = currentUserNickname {
//                let writerNickname = feed.writerNickname
//                let isAuthor = writerNickname == currentUserNickname
//                completion(isAuthor)
//            } else {
//                completion(false) // 사용자가 로그인되어 있지 않은 경우
//            }
//        }
//    }
//    func isCurrentUserAuthor(feed: MyFeed, completion: @escaping (Bool) -> Void) {
//        AuthStore.shared.authenticateUser(for: GIDSignIn.sharedInstance.currentUser, with: nil) { [unowned self] (result, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(false)
//                return
//            }
//
//            guard let currentUserNickname = result?.profile?.nickname else {
//                completion(false) // 사용자가 로그인되어 있지 않은 경우
//                return
//            }
//
//            let writerNickname = feed.writerNickname
//            let isAuthor = writerNickname == currentUserNickname
//            completion(isAuthor)
//        }
//    }


