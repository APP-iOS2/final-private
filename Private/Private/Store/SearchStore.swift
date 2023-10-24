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
    @Published var searchUserResults: [User] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    @MainActor
    func searchUser(searchTerm: String) async {
        self.searchUserResults = []
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
            for newUser in users {
                if !searchUserLists.contains(newUser) {
                    searchUserLists.append(newUser)
                }
                if !searchUserResults.contains(newUser) {
                    searchUserResults.append(newUser)
                }
            }
        } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    
    
    func fetchrecentSearchResult() {
        self.recentSearchResult = self.userDefaults.value(forKey: "SearchResults") as? [String] ?? []
}
    
    func addRecentSearch(_ searchText: String) {
        if searchText != "" {
            if self.recentSearchResult.contains(searchText) || searchText == ""{
                self.removeRecentSearchResult(searchText)
            }
            self.recentSearchResult.insert(searchText, at: 0)
            
        }
        self.setSearchDefaults()
    }
    
    func removeRecentSearchResult(_ resultText: String) {
            for index in 0..<self.recentSearchResult.count {
                if self.recentSearchResult[index] == resultText {
                    self.recentSearchResult.remove(at: index)
                    break
                }
            self.setSearchDefaults()
        }
    }
    
    func removeUserList(_ user: User) {
        if let index = self.searchUserLists.firstIndex(of: user) {
            self.searchUserLists.remove(at: index)
        }
        self.setSearchDefaults()
    }

    
    func setSearchDefaults() {
            self.userDefaults.set(self.recentSearchResult, forKey: "SearchResults")
    }
    
    // userDefaults 초기화 버튼용
//    func resetUserDefaults() {
//        DispatchQueue.main.async {
//            UserDefaults.resetStandardUserDefaults()
//        }
//    }
}
