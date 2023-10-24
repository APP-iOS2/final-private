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
    
    func reverseGeoCoding(lat: String, long: String) {
        let baseURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        
        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": naver_map_client_ID,
            "X-NCP-APIGW-API-KEY": naver_map_client_Secret,
        ]
        
        let parameters: Parameters = [
            "coords": "\(long),\(lat)",
            "output": "json"
        ]
        
        AF.request(baseURL,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200...500)
        .responseDecodable(of: ReverseGeoCodingResult.self) { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        print("success reverseGeoCoding")
                        print(data)
                    }
                }
            case .failure(let error):
                print("fail reverseGeoCoding")
            }
        }
    }
    
    func formatCoordinates(_ input: String, _ index: Int) -> String? {
        if input.count < 7 {
            return nil // 최소 7자리 이상의 문자열이어야 합니다.
        }
        
        // 문자열을 index를 사용하여 처리합니다.
        let index = input.index(input.startIndex, offsetBy: index)
        
        // Substring을 사용하여 3번째와 4번째 문자 앞에 점을 추가합니다.
        var output = input
        output.insert(".", at: index)
        
        return output
    }
    func changeCoordinates(_ input: Double, _ index: Int) -> String? {
 
        let inputString = String(input)
        let index = inputString.index(inputString.startIndex, offsetBy: index)
        var output = inputString
        output.remove(at: output.index(before: index))
        return output

    }

}
