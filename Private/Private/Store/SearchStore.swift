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
    @Published var searchUserLists: [User] = []
    @Published var users = [User]()
    
    let userDefaults: UserDefaults = UserDefaults.standard
    init() {
         fetchUsers()
    }
    
    func fetchUsers() { // 해냈다 ㅠㅠ
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
    
    func setUserDefaults() {
            self.userDefaults.set(self.searchUserLists, forKey: "SearchResults")
    }
    
    func resetUserDefaults() {
            UserDefaults.resetStandardUserDefaults()
    }
}
