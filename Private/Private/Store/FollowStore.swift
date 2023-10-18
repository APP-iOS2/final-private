//
//  FollowStore.swift
//  Private
//
//  Created by 박범수 on 2023/09/25.
// 팔로워(상대방) 팔로잉(내가) 내가 버튼 나의 팔로잉 증가, 상대방 뷰에서는 팔로워가 증가 -> 상대방 팔로워 안에 나의 값이 들어가야, 나의 팔로잉은 상대방의 값이 들어가야하고

import Foundation
import Firebase

final class FollowStore: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
        checkIfUserIsFollowed()
//        fetchUserStats()
    }
    
    func follow() {
        guard let uid = user.id else { return }

        UserService.follow(uid: uid) { _ in
            self.user.isFollowed = true
        }
    }
    
    func unfollow() {
        guard let uid = user.id else { return }
        
        UserService.unfollow(uid: uid) { _ in
            self.user.isFollowed = false
        }
    }
    
    // 이 메소드없으면 프로젝트 재실행 시 디폴트로 unfollow 상태의 뷰가 보인다
    func checkIfUserIsFollowed() {
        guard !user.isCurrentUser else { return } // can't follow oneself
        guard let uid = user.id else { return }

        UserService.checkIfUserIsFollowed(uid: uid) { isFollowed in
            self.user.isFollowed = isFollowed
        }
    }
    
//    func fetchUserStats() {
//        let uid = user.id
//        
//        followingCollection.document(uid).collection("user-following").getDocuments { snapshot, _ in
//            guard let following = snapshot?.documents.count else { return }
//            
//            followerCollection.document(uid).collection("user-followers").getDocuments { snapshot, _ in
//                guard let followers = snapshot?.documents.count else { return }
//                
//                postCollection.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
//                    guard let posts = snapshot?.documents.count else { return }
//                    
//                    self.user.stats = UserStats(following: following, posts: posts, followers: followers)
//                    
//                }
//            }
//        }
//    }
}
