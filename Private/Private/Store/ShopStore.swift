//
//  ShopStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift   //GeoPoint 사용을 위한 프레임워크
import NMapsMap

final class ShopStore: ObservableObject {
    @Published var shopList: [Shop] = []
    
    init() {
        
    }
    
    static let shop = Shop(
        name: "라면맛집",
        category: .koreanFood,
        coord: CodableNMGLatLng(lat: 36.444, lng: 127.332),
        address: "서울 강남구 강남대로 96길 22 2층",
        addressDetail: "7번 출구 어딘가",
        shopTelNumber: "010-1234-5678",
        shopInfo: "미슐랭 맛집",
        shopImageURL: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg",
        shopOwner: "백종원",
        businessNumber: "123-12-1234",
        bookmarks: [],
        menu: [
            ShopItem(name: "돈코츠 라멘", price: 11000, imageUrl: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg"),
            ShopItem(name: "마제소바", price: 10000, imageUrl: "https://www.kfoodtimes.com/news/photo/202105/16015_27303_5527.png"),
            ShopItem(name: "차슈덮밥", price: 12000, imageUrl: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/411/3435af5cc6041f247e89a65b1a1d73c5_res.jpeg")
        ],
        regularHoliday: ["월요일", "화요일", "수요일", "목요일"],
        temporaryHoliday: [Date()],
        breakTimeHours:  [
            "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
            "화요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
            "수요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
            "목요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 18, endMinute: 0),
            "금요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
            "토요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 15, endMinute: 0),
            "일요일": BusinessHours(startHour: 12, startMinute: 0, endHour: 16, endMinute: 0)
        ],
        weeklyBusinessHours:  [
            "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
            "화요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
            "수요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
            "목요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
            "금요일": BusinessHours(startHour:15, startMinute: 0, endHour: 17, endMinute: 0),
            "토요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
            "일요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0)
        ])
    
    
    // 로그인 시 전체 패치 실행
    // MARK: - Fetch ShopData
    @MainActor
    func getAllShopData() async {
        do {
            let documents = try await Firestore.firestore().collection("Shop").getDocuments()
            var tempShopList: [Shop] = []

            for document in documents.documents {
                let data = document.data()
                
                // 카테고리 rawValue의 쓰일 값 미리 받아오기
                guard let categotyRawValue = data["category"] as? Int else {
                    print("카테고리 미입력 =========")
                    return
                }
                
                // NMGLatLng로 쓰일 GeoPoint 미리 받아오기
                guard let location = data["coord"] as? GeoPoint else {
                    print("위치정보 없음 =========")
                    return
                }
                
                // 임시 휴무일: [Timestamp] -> [Date]
                guard let tempHoliday = data["temporaryHoliday"] as? [Timestamp] else {
                    print("휴무일 없음 =========")
                    return
                }
                
                let items: Array<ShopItem> = getReservationItems(document: "reservationItems", data: data)
                let menus: Array<ShopItem> = getReservationItems(document: "menu", data: data)
                let dateArray = tempHoliday.map { $0.dateValue() }
                let breakTimeHoursData = getBusinessTime(document: "breakTimeHours", data: data)
                let businessTimeHoursData = getBusinessTime(document: "weeklyBusinessHours", data: data)
                
                
                let id: String = document.documentID
                let name: String = data["name"] as? String ?? ""
                let category: Category = Category(rawValue: categotyRawValue) ?? .brunch
                let coord: CodableNMGLatLng = location.toCodableNMGLatLng()
                let address: String = data["address"] as? String ?? ""
                let addressDetail: String = data["addressDetail"] as? String ?? ""
                let shopTelNumber: String = data["shopTelNumber"] as? String ?? ""
                let shopInfo: String = data["shopInfo"] as? String ?? ""
                let shopImageURL: String = data["shopImageURL"] as? String ?? ""
                let shopOwner: String = data["shopOwner"] as? String ?? ""
                let businessNumber: String = data["businessNumber"] as? String ?? ""
                let reservationItems: Array<ShopItem>? = items
                let bookmarks: Array<String> = data["bookmarks"] as? [String] ?? []
                let menu: Array<ShopItem> = menus
                let regularHoliday: Array<String> = data["regularHoliday"] as? [String] ?? []
                let temporaryHoliday: Array<Date> = dateArray
                let breakTimeHours: [String: BusinessHours] = breakTimeHoursData
                let weeklyBusinessHours:[String: BusinessHours] = businessTimeHoursData
                
                let shopData: Shop = Shop(id: id, name: name, category: category, coord: coord, address: address, addressDetail: addressDetail, shopTelNumber: shopTelNumber, shopInfo: shopInfo, shopImageURL: shopImageURL, shopOwner: shopOwner, businessNumber: businessNumber, reservationItems: reservationItems, bookmarks: bookmarks, menu: menu, regularHoliday: regularHoliday, temporaryHoliday: temporaryHoliday, breakTimeHours: breakTimeHours, weeklyBusinessHours: weeklyBusinessHours)
                
                tempShopList.append(shopData)
            }
            self.shopList = tempShopList
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // menu, item 받아오는 메소드
    private func getReservationItems(document: String, data: [String: Any]) -> [ShopItem] {
        let reservationItem = data[document] as? [[String: Any]] ?? []
            
            let items = reservationItem.compactMap { itemData in
                if let name = itemData["name"] as? String,
                   let price = itemData["price"] as? Int,
                   let imageUrl = itemData["imageUrl"] as? String {
                    return ShopItem(name: name, price: price, imageUrl: imageUrl)
                } else {
                    print("\(document) 데이터 없음")
                    return ShopItem(name: "error", price: 0, imageUrl: "")
                }
            }
        return items
    }
    
    // 영업시간, 브레이크타임 받아오는 메소드
    private func getBusinessTime(document: String, data: [String: Any]) -> [String: BusinessHours] {
        let businessHourDatas = data[document] as? [String: [String: Int]] ?? [:]
        
        // Dictionary를 "BusinessHours" 구조체로 변환
        var businessHours: [String: BusinessHours] = [:]
        
        for (day, businessTimeData) in businessHourDatas {
            if let startHour = businessTimeData["startHour"],
               let startMinute = businessTimeData["startMinute"],
               let endHour = businessTimeData["endHour"],
               let endMinute = businessTimeData["endMinute"] {
                
                let businessTime: BusinessHours = BusinessHours(startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute)  // 여기에는 데이터가 잘 들어옴
                businessHours[day] = businessTime
            }
        }
        return businessHours
    }
    
    /// reservation의 id를 가지고 Shop 데이터 반환
    func getReservedShop(reservationData: Reservation) -> Shop {
         let reservedShops = self.shopList.filter { $0.id == reservationData.shopId }
        
        if let reservedShop = reservedShops.first {
            return reservedShop
        } else {
            return Self.shop
        }
    }
    
    /// 북마크 추가
    func addBookmark(document: String, userID: String) {
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(document)

        shopRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var originalBookmarks = document.data()?["bookmarks"] as? [String] ?? []
                
                if !originalBookmarks.contains(userID) {
                    originalBookmarks.append(userID)
                    
                    shopRef.updateData(["bookmarks": originalBookmarks]) { error in
                        if let error = error {
                            print("\(error.localizedDescription)")
                        }
                    }
                }
            
//                self.shopList. //
                // 1. 아예 메모리 상의 있는 것만 업데이트
                // 2. 서버로부터 다시 가져와서 published를 재구성(이게 맞음)
                
                
            }
        }
    }
    
//    func fetchShop(document: String, userID: String) {
//        let db = Firestore.firestore()
//        let shopRef = db.collection("Shop").document(document)
//
//        shopRef.getDocument { snapshot, error in
//            if let error = error {
//                print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\(error.localizedDescription)")
//            } else if let shopData = snapshot?.data(), let shop = Shop(documentData: shopData) {
//                self.shop = shop
//                print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
//            }
//        }
//        
//        print("✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨")
//    }
    
    /// 북마크 삭제
    func deleteBookmark(document: String, userID: String) {
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(document)
        
        shopRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var originalBookmarks = document.data()?["bookmarks"] as? [String] ?? []

                if let index = originalBookmarks.firstIndex(of: userID) {
                    originalBookmarks.remove(at: index)

                    shopRef.updateData(["bookmarks": originalBookmarks]) { error in
                        if let error = error {
                            print("\(error.localizedDescription)")
                        }
                    }
                    print("🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵🩵")
                }
            }
        }
    }
    
    /// 사용자가 해당 Shop을 북마크했는지 확인
    func checkBookmark(document: String, userID: String) -> Bool {
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(document)
        var doesBookmarkExist: Bool = false

        shopRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let bookmarks = document.data()?["bookmarks"] as? [String] {
                    if bookmarks.contains(userID) {
                        doesBookmarkExist = true
                    }
                }
            }
        }
        
        print("------------------------------------------------------------------------------------------bool: \(doesBookmarkExist)------------------------------------------------------------------------------------------------------------------------")
        return doesBookmarkExist
        
        // Replace "your_field_name" with the name of the array field you want to search in
//        shopRef.whereField("bookmarks", arrayContains: userID)
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("💗\(error.localizedDescription)💗")
//                } else {
//                    if let documents = querySnapshot?.documents, !documents.isEmpty {
//                        // Data found in Firestore
//                        return true
//                    } else {
//                        // Data not found in Firestore
//                        return false
//                    }
//                }
//            }
    }
    
    /// Shop의 북마크 수
    func checkBookmarkCount(document: String, userID: String, completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(document)

        shopRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let bookmarks = document.data()?["bookmarks"] as? [String] {
                    completion(bookmarks.count)
                } else {
                    completion(0)
                }
            } else {
                completion(0)
            }
        }
    }
    
    func checkBookmarkCounts(document: String, userID: String) -> Int {
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(document)
        var bookmarkCounts: Int = 0

        shopRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let bookmarks = document.data()?["bookmarks"] as? [String] {
                    bookmarkCounts = bookmarks.count
                }
            }
        }
        
        return bookmarkCounts
    }
    
//    func checkBookmark(document: String, userID: String) -> Int {
//        let db = Firestore.firestore()
//        let shopRef = db.collection("Shop").document(document)
//
//        shopRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                if let bookmarks = document.data()?["bookmarks"] as? [String] {
//                    return bookmarks.count
//                }
//            }
//        }
//
//        return 0
//    }
    
    func fetchShop(document: String, userID: String) {
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(document)
        
//        shopRef.getDocument { snapshot, error in
//            if let error = error {
//                print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\(error.localizedDescription)")
//            } else if let shopData = snapshot?.data(), let shop = Shop(documentData: shopData) {
//                self.shop = shop
//                print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
//            }
//            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
//        }
        shopRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let data = document.data()
                var data = [String: Any]()
                data = document.data() ?? [:]
                
                // 카테고리 rawValue의 쓰일 값 미리 받아오기
                guard let categotyRawValue = data["category"] as? Int else {
                    print("카테고리 미입력 =========")
                    return
                }
                
                // NMGLatLng로 쓰일 GeoPoint 미리 받아오기
                guard let location = data["coord"] as? GeoPoint else {
                    print("위치정보 없음 =========")
                    return
                }
                
                // 임시 휴무일: [Timestamp] -> [Date]
                guard let tempHoliday = data["temporaryHoliday"] as? [Timestamp] else {
                    print("휴무일 없음 =========")
                    return
                }
                
                let items: Array<ShopItem> = self.getReservationItems(document: "reservationItems", data: data)
                let menus: Array<ShopItem> = self.getReservationItems(document: "menu", data: data)
                let dateArray = tempHoliday.map { $0.dateValue() }
                let breakTimeHoursData = self.getBusinessTime(document: "breakTimeHours", data: data)
                let businessTimeHoursData = self.getBusinessTime(document: "weeklyBusinessHours", data: data)
                
                let id: String = document.documentID
                let name: String = data["name"] as? String ?? ""
                let category: Category = Category(rawValue: categotyRawValue) ?? .brunch
                let coord: CodableNMGLatLng = location.toCodableNMGLatLng()
                let address: String = data["address"] as? String ?? ""
                let addressDetail: String = data["addressDetail"] as? String ?? ""
                let shopTelNumber: String = data["shopTelNumber"] as? String ?? ""
                let shopInfo: String = data["shopInfo"] as? String ?? ""
                let shopImageURL: String = data["shopImageURL"] as? String ?? ""
                let shopOwner: String = data["shopOwner"] as? String ?? ""
                let businessNumber: String = data["businessNumber"] as? String ?? ""
                let reservationItems: Array<ShopItem>? = items
                let bookmarks: Array<String> = data["bookmarks"] as? [String] ?? []
                let menu: Array<ShopItem> = menus
                let regularHoliday: Array<String> = data["regularHoliday"] as? [String] ?? []
                let temporaryHoliday: Array<Date> = dateArray
                let breakTimeHours: [String: BusinessHours] = breakTimeHoursData
                let weeklyBusinessHours:[String: BusinessHours] = businessTimeHoursData
                
                let shopData: Shop = Shop(id: id, name: name, category: category, coord: coord, address: address, addressDetail: addressDetail, shopTelNumber: shopTelNumber, shopInfo: shopInfo, shopImageURL: shopImageURL, shopOwner: shopOwner, businessNumber: businessNumber, reservationItems: reservationItems, bookmarks: bookmarks, menu: menu, regularHoliday: regularHoliday, temporaryHoliday: temporaryHoliday, breakTimeHours: breakTimeHours, weeklyBusinessHours: weeklyBusinessHours)
            }
        }
        
        print("✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨")
    }
}


extension GeoPoint {
    func toCodableNMGLatLng() -> CodableNMGLatLng {
        return CodableNMGLatLng(lat: self.latitude, lng: self.longitude)
    }
}

extension CodableNMGLatLng {
    func toNMGLatLng() -> NMGLatLng {
        return NMGLatLng(lat: lat, lng: self.lng)
    }
}
