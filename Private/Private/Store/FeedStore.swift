//
//  FeedStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//
import Foundation
import FirebaseStorage
import FirebaseFirestore

final class FeedStore: ObservableObject {
    
    @Published var feedList: [Feed] = []
    private let dbRef = Firestore.firestore().collection("Feed")
    
    init() {
//        feedList.append(FeedStore.feed)
    }
    
//    static let feed = Feed(
//        writer: UserStore.user,
//        images: ["userDefault"],
//        contents: "데이트하기 좋은곳 찾으신다면 추천! 기본은하고 분위기가 좋음. 오므라이스도 맛있다.",
//        visitedShop: ShopStore.shop,
//        category: [Category.koreanFood]
//    )
    
    func addFeed(feedid: String) {
        
    }
   
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
        var imagePath = "images/\(UUID().uuidString).jpg"
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
}
