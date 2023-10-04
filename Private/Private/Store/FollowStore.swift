//
//  FollowStore.swift
//  Private
//
//  Created by 박범수 on 2023/09/25.
//

import Foundation
import Firebase

final class FollowStore: ObservableObject {
    @Published var followers: [User] = []
    @Published var following: [User] = []
    
    @Published var followCheck = false
    
    
    static var db = Firestore.firestore()
    
    static var following = db.collection("following")
    static var followers = db.collection("followers")
    
    static func followingCollection(userid: String) ->  CollectionReference{
        
        return following.document(userid).collection("following")
    }
    
    static func followersCollection(userid: String) ->  CollectionReference{
        
        return followers.document(userid).collection("followers")
    }
    
    static func followingID(userId: String) -> DocumentReference {
        
        return following.document(Auth.auth().currentUser!.uid).collection("following").document(userId)
    }
    
    static func followersID(userId: String) -> DocumentReference {
        
        return followers.document(userId).collection("followers").document(Auth.auth().currentUser!.uid)
    }
    
    func followState(userid: String) {
        FollowStore.followingID(userId: userid).getDocument {
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
    
    func updateFollowCount(userId: String) {
        FollowStore.followingCollection(userid: userId).getDocuments { (snap, error) in
            if let error = error {
                print("Error fetching following users: \(error.localizedDescription)")
            } else if let documents = snap?.documents {
                self.following = documents.compactMap { document in
                    if let user = User(document: document.data()) {
                        return user
                    } else {
                        return nil
                    }
                }
            }
        }
        
        FollowStore.followersCollection(userid: userId).getDocuments { (snap, error) in
            if let error = error {
                print("Error fetching followers users: \(error.localizedDescription)")
            } else if let documents = snap?.documents {
                self.followers = documents.compactMap { document in
                    if let user = User(document: document.data()) {
                        return user
                    } else {
                        return nil
                    }
                }
            }
        }
    }
    
    //팔로우 상태를 체크후 팔로우 언팔로우 하는 함수
    func manageFollow(userId: String, followCheck:Bool) {
        if !followCheck {
            follow(userId: userId)
        } else {
            unfollow(userId: userId)
        }
        
        updateFollowCount(userId: userId)
    }
    //팔로우
    func follow(userId: String) {
        FollowStore.followingID(userId: userId).setData([:]) { (err) in
            if err == nil {
                self.updateFollowCount(userId: userId)
            }
        }
        
        FollowStore.followersID(userId: userId).setData([:]) { (err) in
            if err == nil {
                self.updateFollowCount(userId: userId)
            }
        }
    }
    //언팔로우
    func unfollow(userId: String) {
        FollowStore.followingID(userId: userId).getDocument { (document, err) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                self.updateFollowCount(userId: userId)
            }
        }
        
        FollowStore.followersID(userId: userId).getDocument { (document, err) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                self.updateFollowCount(userId: userId)
            }
        }
    }
    
    func follows(userId: String) {
        updateFollowCount(userId: userId)
    }
    
    func follwers(userId: String) {
        updateFollowCount(userId: userId)
    }
    
}
