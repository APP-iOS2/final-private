//
//  AuthStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/26.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import Combine
import AuthenticationServices
import CryptoKit
import KakaoSDKAuth
import KakaoSDKUser

class AuthStore: ObservableObject {
    @EnvironmentObject var userStore: UserStore
    @Published var currentUser: Firebase.User?
    
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
            
            let userData: [String: Any] = ["email": email, "name": name]
            
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
                                    print("로그인성공1")
                                    self.currentUser = result?.user
                                    self.userStore.createUser(user: user)
                                }
                            }
                        }
                    }
                } else {
                    Firestore.firestore().collection("User").document((user?.profile?.email)!).getDocument { snapshot, error in
                        let currentData = snapshot!.data()
                        
                        Auth.auth().signIn(with: credential) { result, error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            } else {
                                self.currentUser = result?.user
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
    
//    func kakaoAuthSignIn() {
//        if AuthApi.hasToken() {
//            // 발급된 토큰이 있는 지 확인
//            UserApi.shared.accessTokenInfo { accessTokenInfo, error in
//                if let error = error {
//                    self.openKakaoService()
//                } else {
//                    // 토큰이 유효한 경우
////                    self.loadUserInfo(idToken: <#String#>, accessToken: <#String#>)
//                }
//            }
//        } else {
//            // 토큰이 만료된 경우
//            self.openKakaoService()
//        }
//    }
    
    // MARK: - 카카오톡 로그인
    func openKakaoService() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡이 설치되어 있는 경우, 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    print("loginWithKakaoTalk() success.")
                    guard let token = oauthToken else { return }
                    guard let idToken = token.idToken else { return }
                    let accessToken = token.accessToken
                    self.loadUserInfo(idToken: idToken, accessToken: accessToken)
                }
            }
        } else {
            // 카카오톡이 설치가 안 되어 있는 경우, 카카오 계정으로 로그인(웹뷰)
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    guard let token = oauthToken else { return }
                    guard let idToken = token.idToken else { return }
                    let accessToken = token.accessToken
                    self.loadUserInfo(idToken: idToken, accessToken: accessToken)
                }
            }
        }
    }
    
    // MARK: - 카카오톡 유저 정보 받아오기
    func loadUserInfo(idToken: String, accessToken: String) {
        UserApi.shared.me { user, error in
            if let kakaoUser = user {
                let email = kakaoUser.kakaoAccount?.email ?? ""
                let name = kakaoUser.kakaoAccount?.profile?.nickname ?? ""
                let profileImageUrl = kakaoUser.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? "person.fill"
                
                let userData: [String: Any] = ["email": email, "name": name, "profileImageURL": profileImageUrl]
                
                if let error = error {
                    print("카카오톡 유저 불러오기 error: \(error.localizedDescription)")
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                Firestore.firestore().collection("User").whereField("email", isEqualTo: (kakaoUser.kakaoAccount?.email)!)
                    .getDocuments { snapshot, error in
                        if snapshot!.documents.isEmpty {
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                Auth.auth().signIn(with: credential) { [unowned self] (result, error) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        if let user = User(document: userData) {
                                            print("카카오톡 로그인 성공 1")
                                            self.currentUser = result?.user
                                            self.userStore.createUser(user: user)
                                        }
                                    }
                                }
                            }
                        } else {
                            Firestore.firestore().collection("User").document((kakaoUser.kakaoAccount?.email)!).getDocument { (snapshot, error) in
                                let currentData = snapshot!.data()
                                Auth.auth().signIn(with: credential) { result, error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        return
                                    } else {
                                        self.currentUser = result?.user
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - 카카오톡 로그아웃
    func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
}
