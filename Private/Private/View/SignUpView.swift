//
//  SignUpView.swift
//  Private
//
//  Created by 변상우 on 2023/09/27.
//

import SwiftUI

enum Field {
    case nickName
    
}
struct SignUpView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var userStore: UserStore
    @State private var checkNicknameColor: Color = Color.red

    @State private var nickName: String = ""
    @State private var phoneNumber: String = ""
    @State private var cautionNickname: String = ""
    
    @State private var isHiddenCheckButton: Bool = false
    @State private var checkNickname: Bool = false /// 닉네임 중복 확인 Bool 값
    @State private var isNicknameValid: Bool = true
    
    @FocusState private var focusField: Field?
    
    private let phoneNumberMaximumCount: Int = 11  /// 휴대폰 번호 최대 글자수

//    var isNextAvailable: Bool {
//        switch focusField {
//        case .nickName:
//            return !nickName.isEmpty && isValidNickname(nickName)
//        case .none:
//            return false
//        }
//    }
//    var isFieldAllWrite: Bool {
//        return !nickName.isEmpty &&
//        checkNickname == true
//    }
//    텍스트 관련 연산프로퍼티 보류
    var body: some View {
        VStack {
            Spacer()
            Text("Private")
                .font(.pretendardBold28)
                .foregroundStyle(.primary)
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                //MARK: 닉네임
                Text("닉네임")
                    .font(.pretendardBold14)
                    .foregroundStyle(.primary)
                    HStack {
                        TextField("ex) Chris (특수문자 불가)", text: $nickName)
                            .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                            .disableAutocorrection(true) // 자동수정 비활성화
                            .border(isNicknameValid ? Color.clear : Color.accentColor)
                            .focused($focusField, equals: .nickName)
                            .frame(width: .screenWidth*0.70, height: .screenHeight*0.05)
                            .padding(.leading, 5)
                            .background(Color.lightGrayColor)
                            .cornerRadius(7)
                            .onChange(of: nickName) { newValue in
                                ischeckNickname()
                                checkNickname = false
                                nickName = newValue.trimmingCharacters(in: .whitespaces)
                            }
                        
                        Spacer()
                        //MARK: 중복확인
                        if isHiddenCheckButton {
                            Button {
                                Task {
                                    checkNickname = await authStore.doubleCheckNickname(nickname: nickName)
                                    if checkNickname == false && nickName.count > 0 {
                                        cautionNickname = "이미 사용 중인 닉네임"
                                        checkNicknameColor = .red
                                    } else {
                                        cautionNickname = "사용 가능"
                                        checkNicknameColor = .green
                                    }
                                }
                            } label: {
                                if checkNickname == false && true {
                                    Text("중복확인")
                                        .font(.pretendardBold18)
                                        .foregroundStyle(nickName.count >= 0 ? .blue : .secondary)
                                } else {
                                    Text(cautionNickname)
                                        .font(.pretendardBold18)
                                        .foregroundStyle(checkNicknameColor)
                                }
                            }
                            .padding(.trailing, 7)
                        }
                    } // HStack
                if !isValidNickname(nickName) && nickName.count > 0 {
                    Text(cautionNickname)
                        .font(.pretendardMedium16)
                        .foregroundStyle(checkNicknameColor)
                }
                //MARK: 전화번호
                Text("전화번호")
                    .font(.pretendardBold14)
                    .foregroundStyle(.primary)
                TextField("ex) 01098765432 (-)없이", text: $phoneNumber)
                    .disableAutocorrection(true) // 자동수정 비활성화
                    .frame(width: .screenWidth*0.70, height: .screenHeight*0.05)
                    .padding(.leading, 5)
                    .background(Color.lightGrayColor)
                    .cornerRadius(7)
                    .keyboardType(.numberPad)
                    .onChange(of: phoneNumber) { newValue in
                        if newValue.count > phoneNumberMaximumCount {
                            phoneNumber = String(newValue.prefix(phoneNumberMaximumCount))
                        }
                    }
            } // leading VStack
            Button {
                userStore.user.nickname = nickName
                userStore.user.phoneNumber = phoneNumber
                
                    userStore.updateUser(user: userStore.user)
                } label: {
                    Text("정보입력 완료하기")
                }
            .buttonStyle(.borderedProminent)
            .disabled(!checkNickname || phoneNumber.isEmpty)
            .padding()
            
            Button{
                print("로그아웃")
                authStore.signOutGoogle()
            } label: {
                HStack {
                    Text("로그아웃")
                    Image(systemName: "chevron.right")
                }
            }
            Spacer()
        } // 가장 큰 VStack
        .padding(.horizontal, 12)
    } // body
    func ischeckNickname() {
        if isValidNickname(nickName) {
            cautionNickname = ""
            isHiddenCheckButton = true
            checkNicknameColor = .red
        }
        else if (!isValidNickname(nickName) && nickName.count > 0) || nickName == "" {
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserStore())
            .environmentObject(AuthStore())
    }
}
