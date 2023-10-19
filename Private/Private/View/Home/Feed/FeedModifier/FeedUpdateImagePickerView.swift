//
//  FeedUpdateImagePickerView.swift
//  Private
//
//  Created by yeon I on 10/19/23.
//
import SwiftUI
import PhotosUI
import NMapsMap
import FirebaseStorage
import FirebaseFirestore

struct FeedUpdateImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedToUpdateImages: [UIImage]?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
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
        let parent: FeedUpdateImagePickerView
        
        init(_ parent: FeedUpdateImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedToUpdateImages = []
            
            let group = DispatchGroup()
            
            for result in results {
                group.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { [self] (object, error) in
                    if let image = object as? UIImage {
                        parent.selectedToUpdateImages?.append(image)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                picker.dismiss(animated: true)
            }
        }
    }
    
    func uploadUpdateImageToFirebase (image: UIImage) async -> String? {

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
