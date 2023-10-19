//
//  Search.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class SearchStore: ObservableObject {
    @Published var recentSearchResult: [String] = []
    @Published var searchUserLists: [User] = []
    @Published var users: [User] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    
    init() {
        fetchUsers()
        fetchrecentSearchResult()
    }
    
    func fetchUsers() {
            userCollection.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.users = documents.compactMap({ document in
                    let userData = document.data()
                    let user = User(document: userData)
                    return user
                    })
            }
        }
    
    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased() // to prevent case sensitive
        
        return users.filter({ $0.nickname.lowercased().contains(lowercasedQuery) || $0.name.lowercased().contains(lowercasedQuery) })
    }
    
    func searchUser(searchTerm: String) async {
        self.searchUserLists = []
        
        
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

            // searchUserLists 배열에 사용자 추가
            DispatchQueue.main.async {
                self.searchUserLists = users
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    func fetchrecentSearchResult() {
        DispatchQueue.main.async {
            self.recentSearchResult = self.userDefaults.value(forKey: "SearchResults") as? [String] ?? []
        }
    }
    
    func addRecentSearch(_ searchText: String) {
        DispatchQueue.main.async {
            if self.recentSearchResult.contains(searchText) {
                self.removeRecentSearchResult(searchText)
            }
            self.recentSearchResult.insert(searchText, at: 0)
            self.setUserDefaults()
        }
    }
    
    func removeRecentSearchResult(_ resultText: String) {
        DispatchQueue.main.async {
            for index in 0..<self.recentSearchResult.count {
                if self.recentSearchResult[index] == resultText {
                    self.recentSearchResult.remove(at: index)
                    break
                }
            }
            self.setUserDefaults()
        }
    }
    
    func setUserDefaults() {
        DispatchQueue.main.async {
            self.userDefaults.set(self.recentSearchResult, forKey: "SearchResults")
        }
    }
    
    func resetUserDefaults() {
        DispatchQueue.main.async {
            UserDefaults.resetStandardUserDefaults()
        }
    }
}
