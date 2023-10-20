//
//  Search.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import Foundation
import Firebase

final class SearchStore: ObservableObject {
    @Published var recentSearchResult: [String] = []
    @Published var searchUserLists: [User] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
//    init() {
//        fetchUsers()
//    }
//    
//    func fetchUsers() {
//        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
//        
//        userCollection.getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.users = documents.compactMap({ document in
//                let userData = document.data()
//                if let user = User(document: userData), user.id != currentUserId {
//                    return user
//                } else {
//                    return nil
//                }
//            })
//        }
//    }
    
    @MainActor
    func searchUser(searchTerm: String) async {
            let query = userCollection
                         .whereField("nickname", isEqualTo: searchTerm)
                         .limit(to: 10)
            
            do {
                let querySnapshot = try await query.getDocuments()
                
                // 현재 사용자의 ID 가져오기
                guard let currentUserId = Auth.auth().currentUser?.uid else { return }
                
                // 사용자 정의 초기화 메서드를 사용하여 User 객체 생성 및 추가
                let users: [User] = querySnapshot.documents.compactMap { document in
                    let userData = document.data()
                    if let user = User(document: userData), user.id != currentUserId {
                        return user
                    } else {
                        return nil
                    }
                }
//                self.searchUserLists = users
                addUserLists(users)
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    
    func fetchrecentSearchResult() {
        self.recentSearchResult = self.userDefaults.value(forKey: "SearchResults") as? [String] ?? []
}
    
    
    func addRecentSearch(_ searchText: String) {
            if self.recentSearchResult.contains(searchText) || searchText == ""{
                self.removeRecentSearchResult(searchText)
            }
            self.recentSearchResult.insert(searchText, at: 0)
            self.setUserDefaults()
    }
    
    func removeRecentSearchResult(_ resultText: String) {
            for index in 0..<self.recentSearchResult.count {
                if self.recentSearchResult[index] == resultText {
                    self.recentSearchResult.remove(at: index)
                    break
                }
            self.setUserDefaults()
        }
    }
    
    func addUserLists(_ users: [User]) {
        for user in users {
            if !self.searchUserLists.contains(user) {
                self.searchUserLists.insert(user, at: 0)
            }
        }
        self.setUserDefaults()
    }

    
    func removeUserList(_ user: User) {
        if let index = self.searchUserLists.firstIndex(of: user) {
            self.searchUserLists.remove(at: index)
        }
    }

    
    func setUserDefaults() {
            self.userDefaults.set(self.recentSearchResult, forKey: "SearchResults")
    }
    // 초기화 버튼용
//    func resetUserDefaults() {
//        DispatchQueue.main.async {
//            UserDefaults.resetStandardUserDefaults()
//        }
//    }
}
