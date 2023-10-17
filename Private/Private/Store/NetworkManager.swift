//
//  NetworkManager.swift
//  Private
//
//  Created by 박성훈 on 10/16/23.
//

import Foundation

// 데이터 영역에 저장 (열거형, 구조체 다 가능 / 전역 변수로도 선언 가능)
// 사용하게될 API 문자열 묶음
public enum HolidayApi {
    static let requestUrl = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo?"
    static let mediaParam = "pageNo=1&numOfRows=100&_type=json"
    static let key = Bundle.main.publicHoliday_API_KEY
//    static var thisYear: Int = Calendar.current.component(.year, from: Date())
//    static var nextYear: Int = thisYear + 1
//    Calendar.current.component(.year, from: Date()) + 1
}

// 2022 / 2023 / 2024만 모아서 딕셔너리를 합침


//MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class NetworkManager {
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = NetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    typealias NetworkCompletion = (Result<[Item], NetworkError>) -> Void

    // 네트워킹 요청하는 함수 (음악데이터 가져오기)
    func fetchHoliday(year: Int, completion: @escaping NetworkCompletion) {
        let urlString = "\(HolidayApi.requestUrl)ServiceKey=\(HolidayApi.key)&solYear=\(year)&\(HolidayApi.mediaParam)"
        print("holidayURL: \(urlString)")
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }  // URL 구조체 만들기
        let session = URLSession(configuration: .default)  // URLSession 만들기
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let holidays = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(holidays))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ holidayData: Data) -> [Item]? {
        // 성공
        do {
            // 우리가 만들어 놓은 구조체(클래스 등)로 변환하는 객체와 메서드
            // (JSON 데이터 ====> 휴일 구조체)
            let holidayData = try JSONDecoder().decode(HolidayData.self, from: holidayData)
            return holidayData.response.body.items.item
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
