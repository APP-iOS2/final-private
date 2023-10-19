//
//  AuthStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/26.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import Combine
import AuthenticationServices
import CryptoKit
import FirebaseCore
import KakaoSDKAuth
import KakaoSDKUser

enum LoginPlatform {
    case email
    case google
    case kakao
    case none
}

class AuthStore: ObservableObject {
    
    @Published var currentUser: Firebase.User?
    @Published var welcomeToast: Bool = false
    @Published var loginPlatform: LoginPlatform = .none
    
    let userStore: UserStore = UserStore()
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    func signInGoogle() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let cliendID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: cliendID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            
            guard let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            
            GIDSignIn.sharedInstance.configuration = configuration
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                authenticateUser(for: result?.user, with: error)
            }
        }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let googleUser = user {
            let email = googleUser.profile?.email ?? ""
            let name = googleUser.profile?.name ?? ""
            
            let userData: [String: Any] = ["email" : email,
                                           "name" : name,
                                           "nickname" : "",
                                           "phoneNumber" : "",
                                           "profileImageURL" : "",
                                           "follower" : [],
                                           "following" : [],
                                           "myFeed" : [],
                                           "savedFeed" : [],
                                           "bookmark" : [],
                                           "chattingRoom" : [],
                                           "myReservation" : []
            ]
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let idToken = user?.idToken?.tokenString, let accessToken = user?.accessToken.tokenString else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Firestore.firestore().collection("User").whereField("email", isEqualTo: (user?.profile?.email)!).getDocuments { snapshot, error in
                if snapshot!.documents.isEmpty {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        Auth.auth().signIn(with: credential) { [unowned self] (result, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                if let user = User(document: userData) {
                                    self.currentUser = result?.user
                                    welcomeToast = true
                                    self.userStore.createUser(user: user)
                                    self.loginPlatform = .google
                                }
                            }
                        }
                    }
                } else {
                    Firestore.firestore().collection("User").document((user?.profile?.email)!).getDocument { snapshot, error in
                        _ = snapshot!.data()
                        
                        Auth.auth().signIn(with: credential) { result, error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            } else {
                                self.currentUser = result?.user
                                welcomeToast = true
                                self.loginPlatform = .google
                            }
                        }
                    }
                }
            }
        }
    }
    
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func doubleCheckNickname(nickname: String) async -> Bool {
        do {
            let datas = try await Firestore.firestore().collection("User").document(nickname).getDocument()
            if let data = datas.data(), !data.isEmpty {
                return false
            } else {
                return true
            }
        }
        catch {
            debugPrint("getDocument 에러")
            return false
        }
    }
    
    // MARK: - 카카오톡 로그인
    
    /// 카카오톡 설치 여부 확인하는 함수
    func handleKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡이 설치되어 있는 경우, 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(" \(error.localizedDescription)")
                } else {
                    self.loadKakaoUserInfo()
                }
            }
        } else {
            // 카카오톡이 설치가 안 되어 있는 경우, 카카오 계정으로 로그인(웹뷰)
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    self.loadKakaoUserInfo()
                }
            }
        }
    }
    
    /// 카카오톡 유저 정보 받아오는 함수
    func loadKakaoUserInfo() {
        UserApi.shared.me { user, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            if let kakaoUser = user {
                let email = kakaoUser.kakaoAccount?.email ?? ""
                let name = kakaoUser.kakaoAccount?.profile?.nickname ?? ""
                let profileImageUrl = kakaoUser.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? "person.fill"
                
                let userData: [String: Any] = ["email" : email,
                                               "name" : name,
                                               "nickname" : "",
                                               "phoneNumber" : "",
                                               "profileImageURL" : profileImageUrl,
                                               "follower" : [],
                                               "following" : [],
                                               "myFeed" : [],
                                               "savedFeed" : [],
                                               "bookmark" : [],
                                               "chattingRoom" : [],
                                               "myReservation" : []
                ]
                
                Firestore.firestore().collection("User").whereField("email", isEqualTo: (user?.kakaoAccount?.email)!)
                    .getDocuments { snapshot, error in
                        if snapshot!.documents.isEmpty {
                            Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { result, error in
                                if let error = error {
                                    print("\(error.localizedDescription)")
                                } else {
                                    if let user = User(document: userData) {
                                        self.currentUser = result?.user
                                        self.userStore.createUser(user: user)
                                        self.loginPlatform = .kakao
                                    }
                                }
                            }
                        } else {
                            Firestore.firestore().collection("User").document((user?.kakaoAccount?.email)!).getDocument { (snapshot, error) in
                                let currentData = snapshot!.data()
                                
                                Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { result, error in
                                    if let error = error {
                                        print("\(error.localizedDescription)")
                                        return
                                    } else {
                                        self.currentUser = result?.user
                                        self.loginPlatform = .kakao
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    /// 카카오톡 로그아웃
    func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
}
