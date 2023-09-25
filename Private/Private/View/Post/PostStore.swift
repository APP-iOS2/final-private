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



