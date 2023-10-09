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
    private let dbRef = Firestore.firestore().collection("User")
    
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
    
    func addFeed(_ feed: MyFeed) {
        dbRef.document(feed.id).collection("myFeed")
            .document(feed.id)
            .setData(["writer": feed.writer,
                      "images": feed.images,
                      "contents": feed.contents,
                      "createdAt": feed.createdAt,
                      "visitedShop": feed.visitedShop,
                      "category": feed.category,
                     ])
        
        
//        fetchFeed()
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
    
    func updateFeed(_ feed: Feed) {
        dbRef.document(feed.id).updateData([
            "writer" : feed.writer,
            "image" : feed.images,
            "contents" : feed.contents,
            "createdAt" : feed.createdAt,
            "visitedShop": feed.visitedShop,
            "category": feed.category
        ])
    }
}

let feedTestData: Feed = Feed(
    writer: User(),
    images: [],
    contents: "",
    createdAt: 1.1,
    visitedShop: Shop(name: "프라이빗몰", category: .brunch, coord: NMGLatLng(lat: 36.444, lng: 127.332), address: "서울시 은평구", addressDetail: "은평구 아무곳", shopTelNumber: "010-1234-5678", shopInfo: "맛집인증", shopImageURL: "https://post-phinf.pstatic.net/MjAxNzA3MTFfMTA0/MDAxNDk5NzUyNTQ5NzUy.rT1HxpNd3vwvKAMYRKLHjkxiv3D9ymwnHazL2Uf9JKkg.qz5gwLSeDgHluv0xmg95BhD9NYKCbdaN9aQwunYrN1gg.JPEG/GettyImages-467387974.jpg?type=w800_q75", shopOwner: "백종원", businessNumber: "123-12-123", reservationItems: [], bookmarks: [], menu: [
        ShopItem(name: "돈코츠 라멘", price: 11000, imageUrl: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg"),
        ShopItem(name: "마제소바", price: 10000, imageUrl: "https://www.kfoodtimes.com/news/photo/202105/16015_27303_5527.png"),
        ShopItem(name: "차슈덮밥", price: 12000, imageUrl: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/411/3435af5cc6041f247e89a65b1a1d73c5_res.jpeg")
    ], regularHoliday: ["토요일"], temporaryHoliday: [], breakTimeHours: [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "수요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "목요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 18, endMinute: 0),
        "금요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "토요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 15, endMinute: 0),
        "일요일": BusinessHours(startHour: 12, startMinute: 0, endHour: 16, endMinute: 0)
    ], weeklyBusinessHours: [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "수요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "목요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "금요일": BusinessHours(startHour:15, startMinute: 0, endHour: 17, endMinute: 0),
        "토요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "일요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0)
    ]),
    category: [])
//MARK: 킹피셔 보류
//struct ImagePickerView: UIViewControllerRepresentable {
//    @Binding var selectedImages: [String]?
//    let url = URL(string: "https://img.siksinhot.com/place/1527041679181696.PNG?w=560&h=448&c=Y")
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        let imageView = KFImage(url)
//        let hostingController = UIHostingController(rootView: imageView)
//        let picker = PHPickerViewController(configuration: .init())
//        picker.delegate = context.coordinator
//        hostingController.addChild(picker)
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        var parent: ImagePickerView
//
//        init(_ parent: ImagePickerView) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.selectedImages = []
//
//            let group = DispatchGroup()
//
//            for result in results {
//                group.enter()
//
//                result.itemProvider.loadObject(ofClass: UIImage.self) { [self] (object, error) in
//                    if let image = object as? String {
//                        parent.selectedImages?.append(image)
//                    }
//
//                    group.leave()
//                }
//            }
//
//            group.notify(queue: .main) {
//                picker.dismiss(animated: true)
//            }
//        }
//    }
//}

// 킹피셔 예제코드
//if let imageURL = URL(string: "\(shopData.picture)") {
//                    KFImage(imageURL)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 130, height: 130)
//                        .cornerRadius(7)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 7)
//                                .foregroundColor(Color.black.opacity(0.7))
//                                .overlay(
//                                    Text("이용 가능한\n요일이 아닙니다")
//                                        .font(.pretendardSemiBold14)
//                                        .foregroundColor(.white)
//                                )
//                        )
//                }
