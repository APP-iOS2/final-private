//
//  Search.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class SearchStore: ObservableObject {
    @Published var recentSearchResult: [String] = []
    @Published var searchUserLists: [User] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    init() {
        
    }
    
    
    func searchUser(searchTerm: String) async {
        let db = Firestore.firestore()
        
        let query = db.collection("users")
                     .whereField("nickname", isEqualTo: searchTerm)
                     .limit(to: 10)
        
        do {
            let querySnapshot = try await query.getDocuments()
            
            // 사용자 정의 초기화 메서드를 사용하여 User 객체 생성 및 추가
            let users: [User] = querySnapshot.documents.compactMap { document in
                let userData = document.data()
                if let user = User(document: userData) {
                    return user
                } else {
                    return nil
                }
            }

            // searchUserLists 배열에 사용자 추가
            searchUserLists = users
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    func fetchrecentSearchResult() {
        recentSearchResult = userDefaults.value(forKey: "SearchResult") as? [String] ?? []
    }
    
    func addRecentSearch(_ searchText: String) {
        if recentSearchResult.contains(searchText) {
            removeRecentSearchResult(searchText)
        }
        recentSearchResult.insert(searchText, at: 0)
        setUserDefaults()
    }
    
    func removeRecentSearchResult(_ resultText: String) {
        for index in 0..<recentSearchResult.count {
            if recentSearchResult[index] == resultText {
                recentSearchResult.remove(at: index)
                break
            }
        }
        setUserDefaults()
    }
    
    
    
    
    
    
    func setUserDefaults() {
        userDefaults.set(recentSearchResult, forKey: "SearchResults")
    }
    
    func resetUserDefaults() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    
}
