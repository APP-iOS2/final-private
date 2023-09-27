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

class AuthStore: ObservableObject {
    @Published var currentUser: Firebase.User?
    
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
                            self.currentUser = result?.user
                            self.userStore.createUser(user: User(email: (user?.profile?.email)!, name: (user?.profile?.name)!, nickname: "", phoneNumber: "", profileImageURL: "", follower: [], following: [], myFeed: [], savedFeed: [], bookmark: [], chattingRoom: [], myReservation: []))
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
}