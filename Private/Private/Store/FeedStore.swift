//
//  FeedStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage



final class FeedStore: ObservableObject {
    
    // @Published 는 SwiftUI에서 ObservableObject의 프로퍼티가 변경될 때 View를 업데이트하도록 합니다.
    @Published var feedList: [MyFeed] = []
    
    // Firestore 데이터베이스의 "Feed" 컬렉션에 대한 참조를 생성합니다.
    private let feedRef = Firestore.firestore().collection("Feed")
    private let dbRef = Firestore.firestore().collection("User")
    
    // 초기화 함수에서 피드를 가져옵니다.
    init() {
        fetchFeeds()
    }
    // 피드를 Firestore에서 가져오는 함수입니다.
    func fetchFeeds() {
        // Firestore에서 실시간으로 데이터를 가져오기 위해 addSnapshotListener를 사용합니다.
        feedRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            // 에러가 있다면 콘솔에 출력하고 반환합니다.
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            self?.feedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                var feed = MyFeed(documentData: data)
                feed?.createdAt = data["createdAt"] as? Double ?? 0.0 // createdAt 값을 Double로 설정
                return feed
            }
            .sorted(by: { Date(timeIntervalSince1970: $0.createdAt) > Date(timeIntervalSince1970: $1.createdAt) }) ?? []
        }
    }
    
    func addFeed(_ feed: MyFeed) {
        feedRef.document(feed.id).collection("Feed")
            .document(feed.id)
            .setData(["writerNickname": feed.writerNickname,
                      "writerName": feed.writerName,
                      "writerProfileImage": feed.writerProfileImage,
                      "images": feed.images,
                      "contents": feed.contents,
                      "createdAt": feed.createdAt,
                      "title": feed.title,
                      "category": feed.category,
                      "address": feed.address,
                      "roadAddress": feed.roadAddress,
                      "mapx": feed.mapx,
                      "mapy": feed.mapy,
                     ])
    }
    
    //MARK: Feed 객체를 Firestore 데이터로 변환하는 함수입니다.
    private func makeFeedData(from feed: MyFeed) -> [String: Any] {
        return [
            "writerNickname": feed.writerNickname,
            "writerName": feed.writerName,
            "writerProfileImage": feed.writerProfileImage,
            "images": feed.images,
            "contents": feed.contents,
            "createdAt": Timestamp(date: Date(timeIntervalSince1970: feed.createdAt)),
            "title": feed.title,
            "category": feed.category,
            "address": feed.address,
            "roadAddress": feed.roadAddress,
            "mapx": feed.mapx,
            "mapy": feed.mapy,
        ]
    }
    //MARK: Feed 를 삭제하는 함수 입니다
    func deleteFeed(writerNickname: String) {
        // Firestore.firestore().collection("Feed")
        
        // 특정 writerNickname을 가진 피드를 찾아서 삭제
        let query = feedRef.whereField("writerNickname", isEqualTo: writerNickname)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error deleting feed from Firebase: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            for document in documents {
                // 해당 문서를 삭제
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting feed from Firebase: \(error.localizedDescription)")
                    } else {
                        print("Feed deleted from Firebase successfully")
                    }
                }
            }
        }//end deleteFeed
        
        
    }
}
//        func updateFeed(_ feed: MyFeed) {
//            if let selectedImages = selectedImage {
//                var imageUrls: [String] = []
//
//                for image in selectedImages {
//                    guard let imageData = image.jpegData(compressionQuality: 0.2) else { continue }
//                    
//                    let storageRef = storage.reference().child(UUID().uuidString) //
//                    
//                    storageRef.putData(imageData) { _, error in
//                        if let error = error {
//                            print("Error uploading image: \(error)")
//                            return
//                        }
//                        
//                        storageRef.downloadURL { url, error in
//                            guard let imageUrl = url?.absoluteString else { return }
//                            imageUrls.append(imageUrl)
//                            
//                            if imageUrls.count == selectedImages.count {
//                                feed.images = imageUrls
//                                
//                                Firestore.firestore().collection("Feed").document(feed.id).updateData([
//                                    "writerNickname": feed.writerNickname,
//                                    "writerName": feed.writerName,
//                                    "writerProfileImage": feed.writerProfileImage,
//                                    "images": feed.images,
//                                    "contents": feed.contents,
//                                    "createdAt": feed.createdAt,
//                                    "title": feed.title,
//                                    "category": feed.category,
//                                    "address": feed.address,
//                                    "roadAddress": feed.roadAddress,
//                                    "mapx": feed.mapx,
//                                    "mapy": feed.mapy
//                                ]) { error in
//                                    if let error = error {
//                                        print("Error updating feed: \(error.localizedDescription)")
//                                    } else {
//                                        print("Feed updated successfully")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }






/*
 if let selectedImages = selectedImage {
     var imageUrls: [String] = []

     for image in selectedImages {
         guard let imageData = image.jpegData(compressionQuality: 0.2) else { continue }

         let storageRef = storage.reference().child(UUID().uuidString) //

         storageRef.putData(imageData) { _, error in
             if let error = error {
                 print("Error uploading image: \(error)")
                 return
             }

             storageRef.downloadURL { url, error in
                 guard let imageUrl = url?.absoluteString else { return }
                 imageUrls.append(imageUrl)

                 if imageUrls.count == selectedImages.count {

                     feed.images = imageUrls

                     do {
                         try db.collection("User").document(userStore.user.email).collection("MyFeed").document(feed.id) .setData(from: feed)
                     } catch {
                         print("Error saving feed: \(error)")
                     }
                     do {
                         try db.collection("Feed").document(feed.id).setData(from: feed)
                     } catch {
                         print("Error saving feed: \(error)")
                     }
                 }
             }
         }
     }
 }
 
 */
