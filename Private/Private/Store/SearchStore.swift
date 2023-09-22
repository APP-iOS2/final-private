//
//  Search.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import Foundation

final class SearchStore: ObservableObject {
    @Published var recentSearchResult: [String] = []
    @Published var searchUserLists: [User] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    init() {
        
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