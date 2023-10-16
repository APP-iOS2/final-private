//
//  LocationSearchStore.swift
//  Private
//
//  Created by 변상우 on 10/10/23.
//

import SwiftUI
import Alamofire

class LocationSearchStore: ObservableObject {
    static let shared = LocationSearchStore()
    
    private init() { }
    
    @Published var searchResultList = [SearchResult]()
    
    func requestSearchLocationResultList(query: String) {
        let baseURL = "https://openapi.naver.com/v1/search/local.json"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": naver_client_ID,
            "X-Naver-Client-Secret": naver_client_Secret,
        ]
        
        let parameters: Parameters = [
            "query": query,
            "display": 50
        ]
        
        AF.request(baseURL,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200...500)
        .responseDecodable(of: SearchResultList.self) { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        self.searchResultList = data.items
                    }
                }
                print("\(#file) > \(#function) :: SUCCESS")
            case .failure(let error):
                print("\(#file) > \(#function) :: FAILURE : \(error)")
            }
        }
    }
}
