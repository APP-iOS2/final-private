//
//  UserImagePickerView.swift
//  Private
//
//  Created by 주진형 on 2023/10/05.
//
import SwiftUI
import PhotosUI
import UIKit
import Foundation

struct UserImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
       @Environment(\.presentationMode) private var presentationMode

       func makeUIViewController(context: Context) -> UIImagePickerController {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = context.coordinator
           imagePicker.sourceType = .photoLibrary
           return imagePicker
       }

       func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

       func makeCoordinator() -> Coordinator {
           Coordinator(parent: self)
       }

       class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
           let parent: UserImagePickerView

           init(parent: UserImagePickerView) {
               self.parent = parent
           }

           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               if let uiImage = info[.originalImage] as? UIImage {
                   parent.selectedImage = uiImage
               }
               parent.presentationMode.wrappedValue.dismiss()
           }
       }
}
