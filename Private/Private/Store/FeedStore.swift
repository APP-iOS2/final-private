//
//  FeedStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//


/*
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

final class FeedStore: ObservableObject {

    @Published var feedList: [Feed] = []
    
    private let dbRef = Firestore.firestore().collection("Feed")
    static let user = Auth.auth().currentUser
    
    init() {
        fetchFeeds()
    }
    
    static let tempFeed: Feed = {
        // 임시 User 데이터
        let sampleUserData: [String: Any] = [
            "email": "Chadul@gmail.com",
            "name": "김차둘",
            "nickname": "맛집조아",
            "phoneNumber": "010-3333-3333",
            "profileImageURL": "mapuser2",
            "follower": [],
            "following": [],
            "myFeed": [],
            "savedFeed": [],
            "bookmark": [],
            "chattingRoom": [],
            "myReservation": []
        ]
        guard let tempUser = User(document: sampleUserData) else {
            fatalError("Failed to create tempUser")
        }
        
        // 임시 Shop 데이터
        let sampleShopData: [String: Any] = [
            "name": "알라프리마",
            "category": Category.westernFood.rawValue,
            "coord": ["lat": 127.026033, "lng": 37.513526],
            "address": "서울 강남구 학동로17길 13 인본",
            "addressDetail": "논현동 42-6",
            "shopTelNumber": "02-511-2555",
            "shopInfo": "늘 과감하고 창의적인 요리로 미식가들의 발길을 유혹하는 알라 프리마. 오픈된 주방이 한눈에 들어오는 넓은 카운터 테이블과 쾌적한 다이닝 홀, 그리고 프라이빗 다이닝 공간이 모던하게 펼쳐진다. 재료를 생명으로 여기는 김진혁 셰프의 요리는 깔끔한 소스, 맛의 밸런스, 그리고 계절 식재료들의 향연이라 할 수 있다. 와인뿐만 아니라 사케와도 잘 어울리는 이 곳의 모던 퀴진을 경험하려면 예약은 필수다.",
            "shopImageURL": "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/8a8bef0610f647a78854786aae405fa5?w=53&org_if_sml=1",
            "shopOwner": "알라프리마 오너",
            "businessNumber": "123-45-67890",
            "bookmarks": ["user1", "user2"],
            // 예시 메뉴 항목
            "menu": [
                ["name": "lunch course", "price": 80000, "imageUrl": "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/8a8bef0610f647a78854786aae405fa5?w=53&org_if_sml=1"],
                ["name": "dinner course", "price": 80000, "imageUrl": "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/8a8bef0610f647a78854786aae405fa5?w=53&org_if_sml=1"]
            ],
            "regularHoliday": ["일요일"],
            "temporaryHoliday": [],
            "breakTimeHours": [:], // 별도의 브레이크 타임 정보가 필요하면 여기에 추가
            "weeklyBusinessHours": [:], // 별도의 영업 시간 정보가 필요하면 여기에 추가
            "reservationItems": [
                ["name": "dinner course", "price": 80000, "imageUrl": "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/8a8bef0610f647a78854786aae405fa5?w=53&org_if_sml=1"]
            ]
        ]
        guard let tempShop = Shop(documentData: sampleShopData) else {
            fatalError("Failed to create tempShop")
        }
        // Feed 데이터
        let feed = Feed(
            writer: tempUser,
            images: ["image1_url", "image2_url"],
            contents: "오늘 여친이랑 같이 갔어요. 여친 생일이라 큰맘 먹었는데 , 플레이팅 너무 감동적이었어요 근데 계산할땐 감동이 아니라 슬펐어요.ㅜㅜ",
            visitedShop: tempShop,
            category: [.westernFood]
        )
        
        return feed
    }()
    
    
    // MARK: - 피드추가
    ///피드 추가하기
    func addFeed(_ feed: Feed) {
    let documentRef = dbRef.document(feed.id)
    
    let feedData = makeFeedData(from: feed)
        
    documentRef.setData(feedData) { error in
        if let error = error {
            print("Error adding feed: \(error.localizedDescription)")
        } else {
            print("Feed added to Firestore")
        }
    }
}


    // MARK: 피드 이미지 삭제
    func removeImage(_ image: Feed) {
        var index: Int = 0
        
        for tempImage in feedList {
            
            if tempImage.id == image.id {
                feedList.remove(at: index)
                break
            }
            index += 1
        }
    }

    func uploadImageToFirebase (image: UIImage) async -> String? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return nil }
        let imagePath = "images/\(UUID().uuidString).jpg"
        let imageRef = Storage.storage().reference().child(imagePath)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        do {
            let _ = try await imageRef.putDataAsync(imageData)
            let url = try await imageRef.downloadURL()
            return url.absoluteString
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    // MARK: - 피드 업데이트
    func updateFeed(_ feed: Feed) {
        let documentRef = dbRef.document(feed.id)
        
        let feedData = makeFeedData(from: feed)
        
        documentRef.updateData(feedData) { error in
            if let error = error {
                print("Error updating feed: \(error.localizedDescription)")
            } else {
                print("Feed updated on Firestore")
            }
        }
    }

    // Feed 객체로부터 Firestore에 저장할 수 있는 데이터를 만듭니다.
    private func makeFeedData(from feed: Feed) -> [String: Any] {
        return [
            "writerId": feed.writer.id,  // 사용자 ID만 저장합니다.
            "images": feed.images,
            "contents": feed.contents,
            "createdAt": Timestamp(date: Date(timeIntervalSince1970: feed.createdAt)),
            "visitedShopId": feed.visitedShop.id,  // 매장 ID만 저장합니다.
            "category": feed.category.map { $0.rawValue }
        ]
    }
    // MARK: - 피드조회
    /// 서버에서 예약내역 가져오기
    func fetchFeeds() {
        print(#file, #function, #line, "sdfsdlfdslf")
        // 현재 로그인한 사용자가 없다면 오류 메시지를 출력하고 함수를 종료합니다.
        guard let user = Auth.auth().currentUser else {
            print("로그인 정보가 없습니다.")
            return
        }
        
        // 현재 로그인한 사용자의 이메일 주소가 없다면 오류 메시지를 출력하고 함수를 종료합니다.
        guard let email = user.email else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        // Firestore에서 Feed 데이터를 가져옵니다.
        dbRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            // 에러가 있다면 오류 메시지를 출력하고 함수를 종료합니다.
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            // 문서 데이터가 없다면 오류 메시지를 출력하고 함수를 종료합니다.
            guard let documents = querySnapshot?.documents else {
                print("documents: No documents")
                return
            }
            // 문서 데이터를 Feed 타입으로 변환하고 feedList를 업데이트합니다.
            // [weak self]와 guard let self = self else { return }를 사용하여 메모리 릭을 방지합니다.
            self?.feedList = documents.compactMap { (queryDocumentSnapshot) -> Feed? in
                let data = queryDocumentSnapshot.data()
                return Feed(documentData: data)
            }
            print(#file, #function, #line, "documents: \(documents.count)")
        }
    }
}
*/
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


final class FeedStore: ObservableObject {
    
    // @Published 는 SwiftUI에서 ObservableObject의 프로퍼티가 변경될 때 View를 업데이트하도록 합니다.
    @Published var feedList: [Feed] = []

    // Firestore 데이터베이스의 "Feed" 컬렉션에 대한 참조를 생성합니다.
    private let dbRef = Firestore.firestore().collection("Feed")
    
    // 초기화 함수에서 피드를 가져옵니다.
    init() {
        fetchFeeds()
    }
    // 피드를 Firestore에서 가져오는 함수입니다.
    func fetchFeeds() {
        // Firestore에서 실시간으로 데이터를 가져오기 위해 addSnapshotListener를 사용합니다.
        dbRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            // 에러가 있다면 콘솔에 출력하고 반환합니다.
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            // 문서 데이터를 Feed 타입으로 변환하고 feedList를 업데이트합니다.
            self?.feedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> Feed? in
                let data = queryDocumentSnapshot.data()
                return Feed(documentData: data)
            } ?? []  // 문서가 없다면 빈 배열을 할당합니다.
        }
    }
    // 새로운 피드를 Firestore에 추가하는 함수입니다.
    func addFeed(_ feed: Feed) {
        // 새로운 문서의 참조를 생성합니다.
        let documentRef = dbRef.document(feed.id)
        
        // Feed 객체를 Firestore 데이터로 변환합니다.
        let feedData = makeFeedData(from: feed)
        
        // 데이터를 Firestore에 추가합니다.
        documentRef.setData(feedData) { error in
            if let error = error {
                print("Error adding feed: \(error.localizedDescription)")
            } else {
                print("Feed successfully added to Firestore")
            }
        }
    }
    
    // Feed 객체를 Firestore 데이터로 변환하는 함수입니다.
    private func makeFeedData(from feed: Feed) -> [String: Any] {
        return [
            "writerId": feed.writer.id,
            "images": feed.images,
            "contents": feed.contents,
            "createdAt": Timestamp(date: Date(timeIntervalSince1970: feed.createdAt)),
            "visitedShopId": feed.visitedShop.id,
            "category": feed.category.map { $0.rawValue }
        ]
    }
    // 이미지를 Firebase Storage에 업로드하는 함수입니다.
        func uploadImageToFirebase(image: UIImage, completion: @escaping (String) -> Void) {
            // 이미지의 데이터를 JPEG 형식으로 변환합니다. 품질은 0.1로 설정합니다.
            guard let imageData = image.jpegData(compressionQuality: 0.1) else {
                print("Could not convert image to data")
                return
            }
            
            // 이미지를 저장할 경로를 설정합니다. 여기서는 "images" 폴더 아래에 현재 시간을 이름으로 하는 방식을 사용합니다.
            let imageName = "\(Date().timeIntervalSince1970)"
            let imageRef = Storage.storage().reference().child("images/\(imageName).jpg")
            
            // 이미지를 업로드합니다.
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                // 업로드된 이미지의 다운로드 URL을 가져옵니다.
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    if let downloadURL = url?.absoluteString {
                        // 완료 핸들러에 다운로드 URL을 전달합니다.
                        completion(downloadURL)
                    }
                }
            }
        }
        
        // 피드를 업데이트하는 함수입니다.
        func updateFeed(_ feed: Feed) {
            // 업데이트할 문서의 참조를 생성합니다.
            let documentRef = dbRef.document(feed.id)
            
            // Feed 객체를 Firestore 데이터로 변환합니다.
            let feedData = makeFeedData(from: feed)
            
            // 데이터를 Firestore에 업데이트합니다.
            documentRef.updateData(feedData) { error in
                if let error = error {
                    print("Error updating feed: \(error.localizedDescription)")
                } else {
                    print("Feed successfully updated in Firestore")
                }
            }
        }
}
