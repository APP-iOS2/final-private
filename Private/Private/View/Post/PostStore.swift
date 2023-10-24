//
//  PostStore.swift
//  Private
//
//  Created by 최세근 on 2023/09/25.
//
import SwiftUI
import PhotosUI
import NMapsMap
import FirebaseStorage
import FirebaseFirestore

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images 
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages = []
            
            let group = DispatchGroup()
            
            for result in results {
                group.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { [self] (object, error) in
                    if let image = object as? UIImage {
                        parent.selectedImages?.append(image)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                picker.dismiss(animated: true)
            }
        }
    }
}

final class PostStore: ObservableObject {
    
    @Published var feedList: [MyFeed] = []
    private let dbRef = userCollection
    
    var feedId: String = ""
    
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
//    func fetchFeed() {
//        dbRef.document(feedId).collection("User").getDocuments { (snapshot, error) in
//            self.feedList.removeAll()
//            if let snapshot {
//                var tempReplies: [MyFeed] = []
//                
//                for document in snapshot.documents {
//                    let id: String = document.documentID
//                    
//                    let docData: [String : Any] = document.data()
//                    let writer: String = docData["writer"] as? String ?? ""
//                    let images: [String] = docData["images"] as? [String] ?? []
//                    let contents: String = docData["contents"] as? String ?? ""
//                    let createdAt: Double = docData["createdAt"] as? Double ?? 0
//                    let visitedShop: String = docData["visitedShop"] as? String ?? ""
//                    let category: [String] = docData["category"] as? [String] ?? []
//                    
//                    let myFeed = MyFeed(writer: writer, images: images, contents: contents, createdAt: createdAt, visitedShop: visitedShop, category: category)
//                    
//                    tempReplies.append(myFeed)
//                }
//                self.feedList = tempReplies
//            }
//        }
//    }

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
}

