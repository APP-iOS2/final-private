//
//  PrivateApp.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI
import FirebaseCore

@main
struct PrivateApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(FeedStore())
                .environmentObject(SearchStore())
                .environmentObject(ChatRoomStore())
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
