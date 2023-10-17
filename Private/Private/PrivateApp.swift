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

@main
struct PrivateApp: App {
    
    @StateObject private var userStore = UserStore()
    @StateObject private var reservationStore = ReservationStore()
    @StateObject private var shopStore = ShopStore()
    @StateObject private var holidayManager = HolidayManager()
    
    init() {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(AuthStore())
                .environmentObject(userStore)
                .environmentObject(FeedStore())
                .environmentObject(SearchStore())
                .environmentObject(ChatRoomStore())
                .environmentObject(reservationStore)
                .environmentObject(shopStore)
                .environmentObject(holidayManager)
                .task {
                    await shopStore.getAllShopData()
//                    await NetworkManager.shared.fetchHoliday { result in
//                        print(#fileID, #function, #line, "- 휴일 받아오기")
//                        switch result {
//                        case .success(let holidayDatas):
//                            // 데이터(배열)을 받아오고 난 후
//                            self.holidayArrays = holidayDatas
//    //                        print("Holiday Date: \(holidayArrays[0].getDate()) ===")
//                            DispatchQueue.main.async {
//                                publicHolidays = holidayArrays.map { $0.toDictionary() }
//                                print("publicHolidays: \(publicHolidays) !!!!")
//                            }
//                            
//                        case .failure(let error):
//                            print(error.localizedDescription)
//                        }
//                    }
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
