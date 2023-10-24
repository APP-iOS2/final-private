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
    @EnvironmentObject var authStore: AuthStore
    @State private var checkNicknameColor: Color = Color.red
    @State private var cautionNickname: String = ""
    @State private var checkNickname: Bool = false
    @State private var isHiddenCheckButton: Bool = false
    @State private var isNicknameValid: Bool = true
    @Binding var isModify: Bool
    @State var mypageNickname: String = ""
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
                                .foregroundColor(Color(.private))
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
                VStack (alignment: .leading) {
                    HStack {
                        Text("닉네임")
                            .font(.pretendardBold18)
                            .foregroundColor(.primary)
                            .frame(width: .screenWidth * 0.2)
                            .padding(.trailing, 5)
                        TextField("\(userStore.user.nickname)", text: $mypageNickname)
                            .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                            .disableAutocorrection(true) // 자동수정 비활성화
                            .border(isNicknameValid ? Color.clear : Color.privateColor)
                            .font(.pretendardRegular16)
                        //.focused($focusField, equals: .mypageNickname)
                        //.frame(width: .screenWidth*0.70, height: .screenHeight*0.05)
                            .padding(.leading, 5)
                            .onChange(of: mypageNickname) { newValue in
                                ischeckNickname()
                                checkNickname = false
                                mypageNickname = newValue.trimmingCharacters(in: .whitespaces)
                            }
                        
                        
                        if isHiddenCheckButton {
                            Button {
//                                Task {
//                                    checkNickname = await authStore.doubleCheckNickname(nickname: mypageNickname)
//                                    if checkNickname == false && mypageNickname.count > 0 {
//                                        cautionNickname = "이미 사용 중인 닉네임"
//                                        checkNicknameColor = .red
//                                    } else {
//                                        cautionNickname = "사용 가능"
//                                        checkNicknameColor = .green
//                                    }
//                                }
                                userStore.checkNickName(mypageNickname) { exists in
                                    if exists {
                                        cautionNickname = "이미 사용 중인 닉네임"
                                        checkNicknameColor = .red
                                        checkNickname = false
                                        print("이미 사용중")
                                        userStore.clickIsSavedNickName = true
                                        } else {
                                            checkNickname = true
                                            cautionNickname = "사용 가능"
                                            checkNicknameColor = .green
                                        }
                                }
                            } label: {
                                if checkNickname == false && true {
                                    Text("중복확인")
                                        .font(.pretendardRegular12)
                                        .foregroundStyle(mypageNickname.count >= 0 ? .blue : .secondary)
                                } else {
                                    Text(cautionNickname)
                                        .font(.pretendardRegular12)
                                        .foregroundStyle(checkNicknameColor)
                                }
                            }
                            .padding(.trailing, 7)
                        }
                    }
                    if !isValidNickname(mypageNickname) && mypageNickname.count > 0 {
                        Text(cautionNickname)
                            .font(.pretendardMedium16)
                            .foregroundStyle(checkNicknameColor)
                    }
                }
                .padding([.leading,.trailing], 28)
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
                if mypageNickname == "" {
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
                } else {
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
                            .foregroundColor(checkNicknameColor == .green ? .privateColor : .primary.opacity(0.5))
                    }
                    .disabled(checkNicknameColor != .green)
                }
            }
        }
        .popup(isPresented: $userStore.clickIsSavedNickName){
            ToastMessageView(message: "이미 사용중인 닉네임 입니다!")
                .onDisappear {
                    userStore.clickSavedFeedToast = false
                }
        } customize: {
            $0
                .autohideIn(2)
                .type(.floater(verticalPadding: 20))
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.clear)
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
    func ischeckNickname() {
        if isValidNickname(mypageNickname) {
            cautionNickname = ""
            isHiddenCheckButton = true
            checkNicknameColor = .red
        }
        else if !isValidNickname(mypageNickname) && mypageNickname.count > 0 {
            cautionNickname = "닉네임 형식이 맞지 않습니다."
            isHiddenCheckButton = false
            checkNicknameColor = .red
        }
    }
    func isValidNickname(_ nickName: String) -> Bool {
        let nicknameExpression = "^[a-zA-Z0-9]+$"
        
        let nickNamePredicate = NSPredicate(format:"SELF MATCHES %@", nicknameExpression)
        return nickNamePredicate.evaluate(with: nickName)
    }
}

struct UserInfoModifyView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoModifyView(isModify: .constant(true), mypageNickname: "").environmentObject(UserStore())
    }
}
