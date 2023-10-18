//
//  UserService.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import Firebase

struct UserService {
    static func follow(uid: String, completion: ((Error?) -> Void)?) {
        guard let currentUid = AuthStore.shared.currentUser?.uid else { return }
        
        
        followingCollection.document(currentUid)
            .collection("user-following").document(uid).setData([:]) { _ in
                followerCollection.document(uid).collection("user-followers")
                    .document(currentUid).setData([:], completion: completion)
            }
    }
    
    static func unfollow(uid: String, completion: ((Error?) -> Void)?) {
        guard let currentUid = AuthStore.shared.currentUser?.uid else { return }
        
        followingCollection.document(currentUid)
            .collection("user-following").document(uid).delete() { _ in
                followerCollection.document(uid)
                    .collection("user-follwers").document(currentUid).delete(completion: completion) // completion 후 내 코드의 completion handler 실행 후 동작
            }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = AuthStore.shared.currentUser?.uid else { return }
        
        followingCollection.document(currentUid).collection("user-following")
            .document(uid).getDocument { snapshot, _ in
                guard let isFollowed = snapshot?.exists else { return }
                completion(isFollowed)
            }
    }
}
