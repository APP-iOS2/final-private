//
//  PrivateApp.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct PrivateApp: App {
    
    @StateObject private var userStore = UserStore()
    @StateObject private var feedStore = FeedStore()
    @StateObject private var reservationStore = ReservationStore()
    @StateObject private var shopStore = ShopStore()
    @StateObject private var holidayManager = HolidayManager()
    @StateObject private var followStore = FollowStore()
    @StateObject private var searchStore = SearchStore()
    
    init() {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        
        // Kakao SDK 초기화
        let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? "KAKAO_NATIVE_APP_KEY is nil"
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(AuthStore())
                .environmentObject(userStore)
                .environmentObject(feedStore)
                .environmentObject(searchStore)
                .environmentObject(ChatRoomStore())
                .environmentObject(reservationStore)
                .environmentObject(shopStore)
                .environmentObject(holidayManager)
                .environmentObject(followStore)
                .task {
                    await shopStore.getAllShopData()
                }
                .onOpenURL { url in
                    // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
                    // 카카오 로그인을 위해선 웹 혹은 카카오톡 앱으로 이동한 다음, 다시 앱으로 돌아오는 과정을 거쳐야 한다. 따라서 Handler를 추가로 등록해준다.
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    /// 구글 로그인 인증 프로세스가 끝날 때 애플리케이션이 수신하는 URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
