//
//  PostStore.swift
//  Private
//
//  Created by 최세근 on 2023/09/25.
//
import SwiftUI
import PhotosUI


struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0  // Set the desired selection limit (0 for unlimited)
        configuration.filter = .images  // Filter for images only
        
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
