//
//  UserInfoModifyView.swift
//  Private
//
//  Created by 주진형 on 2023/09/27.
//

import SwiftUI
import Kingfisher
import FirebaseStorage

struct UserInfoModifyView: View {
    @EnvironmentObject private var userStore: UserStore
    @Binding var isModify: Bool
    @State var mypageNickname: String
    @State var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    var storage = Storage.storage()
    var body: some View {
        NavigationStack {
            ScrollView {
                Button {
                    isImagePickerPresented.toggle()
                } label: {
                    ZStack {
                        if userStore.user.profileImageURL.isEmpty {
                            Circle()
                                .frame(width: .screenWidth*0.23)
                                .foregroundColor(.primary)
                            if ((selectedImage) != nil) {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: .screenWidth*0.25, height: .screenWidth*0.25)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: .screenWidth*0.23,height: 80)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                            }
                            
                        } else {
                            if ((selectedImage) != nil) {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: .screenWidth*0.25, height: .screenWidth*0.25)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            } else {
                                KFImage(URL(string: userStore.user.profileImageURL))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: .screenWidth*0.25, height: .screenWidth*0.25)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            }
                        }
                        ZStack {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("AccentColor"))
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 25, height: 20)
                                .foregroundColor(.black)
                        }
                        .padding([.top, .leading], 55)
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    UserImagePickerView(selectedImage: $selectedImage)
                }
                Divider()
                    .background(Color.primary)
                    .frame(width: .screenWidth*0.9)
                    .padding([.top,.bottom],15)
                HStack {
                    Text("닉네임")
                        .font(.pretendardMedium18)
                        .foregroundColor(.primary)
                    TextField("\(userStore.user.nickname)", text: $mypageNickname)
                        .padding(.leading, 5)
                }
                .padding([.leading,.trailing], 28)
                HStack {}
                HStack {}
                HStack {}
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(userStore.user.nickname))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isModify = false
                } label: {
                    Text("취소")
                        .font(.pretendardSemiBold16)
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if mypageNickname != "" {
                        userStore.user.nickname = mypageNickname
                    }
                    if selectedImage != nil {
                        uploadimage(img: selectedImage!)
                    }
                    userStore.updateUser(user: userStore.user)
                    isModify = false
                } label: {
                    Text("수정")
                        .font(.pretendardSemiBold16)
                        .foregroundColor(.privateColor)
                }
            }
        }
    }
    func uploadimage(img: UIImage) {
        let imageData = img.jpegData(compressionQuality: 0.2)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let storageRef = storage.reference().child(UUID().uuidString + ".jpg")
        storageRef.putData(imageData,metadata: metaData) {
            (metaData,error) in if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("사진 올리기 성공")
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("이미지 URL 가져오기 실패: \(error.localizedDescription)")
                }
                if let imageUrl = url {
                    userStore.user.profileImageURL = imageUrl.absoluteString
                    userStore.updateUser(user: userStore.user)
                }
            }
        }
    }
}

struct UserInfoModifyView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoModifyView(isModify: .constant(true), mypageNickname: "").environmentObject(UserStore())
    }
}
