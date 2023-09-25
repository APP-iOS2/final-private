//
//  FollowStore.swift
//  Private
//
//  Created by 박범수 on 2023/09/25.
//

import Foundation
import Firebase

final class FollowStore: ObservableObject {
    @Published var followers = 0
    @Published var following = 0
    
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
    
    func manageFollow(userId: String, followCheck:Bool, followingCount: @escaping
            (_ followingCount: Int) -> Void, followersCount: @escaping
            (_ followingCount: Int) -> Void) {
        
        if !followCheck {
//            follow()
        } else {
//            unfollow()
        }
    }
    
    
    
    
    func follows(userId: String) {
        FollowStore.followingCollection(userid: userId).getDocuments { (QuerySnapshot, err) in
            
            if let doc = QuerySnapshot?.documents {
                self.following = doc.count
            }
        }
    }
    
    func follwers(userId: String) {
        
        FollowStore.followersCollection(userid: userId).getDocuments { (QuerySnapshot, err) in
            
            if let doc = QuerySnapshot?.documents {
                self.followers = doc.count
            }
        }
    }
    
}



