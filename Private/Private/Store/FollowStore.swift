//
//  FollowStore.swift
//  Private
//
//  Created by 박범수 on 2023/09/25.
// 팔로워(상대방) 팔로잉(내가) 내가 버튼 나의 팔로잉 증가, 상대방 뷰에서는 팔로워가 증가 -> 상대방 팔로워 안에 나의 값이 들어가야, 나의 팔로잉은 상대방의 값이 들어가야하고

import Foundation
import Firebase

final class FollowStore: ObservableObject {
    @Published var followers = 0
    @Published var following = 0
    
    @Published var followCheck = false
    
    
    static var db = Firestore.firestore()
    static var UserCollection = db.collection("User")
    static let currentUserRef = UserCollection.document("currentUserID")
    
    
    static func followingCollection(userid: String) ->  CollectionReference{
        
        return UserCollection.document(userid).collection("following")
    }
    
    static func followersCollection(userid: String) ->  CollectionReference{
        
        return UserCollection.document(userid).collection("follower")
    }
    
    static func followingID(nickname: String) -> DocumentReference {
        
        return UserCollection.document((Auth.auth().currentUser?.email)!).collection("following").document("FollowingList")
    }
    
    static func followersID(email: String, nickname: String) -> DocumentReference {
        
        return UserCollection.document(email).collection("follower").document(nickname)
    }
    
    func followState(userid: String) {
        FollowStore.followingID(nickname: userid).getDocument {
            (document, error) in
            
            if let doc = document, doc.exists {
                self.followCheck = true
            } else {
                self.followCheck = false
            }
        }
    }
    
    
    func updateFollowCount(userId: String, followingCount: @escaping
                           (_ followingCount: Int) -> Void, followersCount: @escaping
                           (_ followingCount: Int) -> Void) {
        
        FollowStore.followingCollection(userid: userId).getDocuments { (snap, error) in
            
            if let doc = snap?.documents {
                followingCount(doc.count)
            }
        }
        
        FollowStore.followersCollection(userid: userId).getDocuments { (snap, error) in
            
            if let doc = snap?.documents {
                followersCount(doc.count)
            }
        }
    }
    
    //팔로우 상태를 체크후 팔로우 언팔로우 하는 함수
    func manageFollow(userId: String, myNickName: String, userEmail: String, followingCount:
                      @escaping (_ followingCount: Int)-> Void, followersCount:
                      @escaping (_ followersCount: Int)-> Void) {
        
        if !followCheck {
            follow(userId: userId, myNickName: myNickName, OtherEmail: userEmail, followingCount: followingCount, followersCount: followersCount)
        } else {
            unfollow(userId: userId, myNickName: myNickName, userEmail: userEmail, followingCount: followingCount, followersCount: followersCount)
        }
    }
    
    //팔로우
    func follow(userId: String, myNickName: String, OtherEmail: String, followingCount:
                @escaping (_ followingCount: Int)-> Void, followersCount:
                @escaping (_ followersCount: Int)-> Void) {
        
        FollowStore.followingID(nickname: userId).setData(["following": FieldValue.arrayUnion([userId])]) { (err) in
            if err == nil {
                self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
            }
        }
        
        FollowStore.followersID(email: OtherEmail, nickname: myNickName).setData(["follower": FieldValue.arrayUnion([myNickName])]) { (err) in
            if err == nil {
                self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
            }
        }
    }
    
    //언팔로우
    func unfollow(userId: String, myNickName: String, userEmail: String, followingCount:
                  @escaping (_ followingCount: Int)-> Void, followersCount:
                  @escaping (_ followersCount: Int)-> Void) {
        
            FollowStore.followingID(nickname: userId).getDocument { (document, err) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
            }
        }
        
        FollowStore.followersID(email: userId, nickname: myNickName).getDocument { (document, err) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                self.updateFollowCount(userId: userId, followingCount: followingCount, followersCount: followersCount)
            }
        }
    }
    
//    func follows(userId: String) {
//        updateFollowCount(userId: userId)
//    }
//    
//    func follwers(userId: String) {
//        updateFollowCount(userId: userId)
//    }
    
}
