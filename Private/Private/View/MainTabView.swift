//
//  MainTabView.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI
import NMapsMap

struct MainTabView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.tabColor)
    }
    @EnvironmentObject var followStore: FollowStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var searchStore: SearchStore
  
    @StateObject private var feedStore: FeedStore = FeedStore()
//    @StateObject private var searchStore: SearchStore = SearchStore()
    @State private var coord: NMGLatLng = NMGLatLng(lat: 0.0, lng: 0.0)

    @State var selection: Int = 1
    @State private var rootSection1: Bool = false
    @State private var rootSection2: Bool = false
    @State private var rootSection3: Bool = false
    @State private var rootSection4: Bool = false
    @State private var rootSection5: Bool = false
    
    @State private var showLocation: Bool = false
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    var selectionBinding: Binding<Int> { Binding (
        get: {
            self.selection
        },
        set: {
            if $0 == self.selection && rootSection1 {
                rootSection1 = false
            }
            if $0 == self.selection && rootSection2 {
                rootSection2 = false
            }
            if $0 == self.selection && rootSection3 {
                rootSection3 = false
            }
            if $0 == self.selection && rootSection4 {
                rootSection4 = false
            }
            if $0 == self.selection && rootSection4 {
                rootSection5 = false
            }
            self.selection = $0
        }
    )}
    
    var nicknameIsEmpty: Bool {
        return userStore.user.nickname.isEmpty
    }
    
    
    var body: some View {
        if nicknameIsEmpty {
            SignUpView()
        } else {
            NavigationStack {
                TabView(selection: selectionBinding) {
                    MainHomeView(root: $rootSection1, selection: $selection, showLocation: $showLocation, searchResult: $searchResult).tabItem {
                        Image(systemName: "house.fill")
                    }.tag(1)
                    SearchView(root: $rootSection2, selection: $selection).tabItem {
                        Image(systemName: "magnifyingglass")
                            .environmentObject(followStore)
                    }.tag(2)
                    UploadView(root: $rootSection3, selection: $selection, isImagePickerPresented: .constant(true), showLocation: $showLocation, searchResult: $searchResult, coord: $coord).tabItem {
                        Image(systemName: "plus")
                    }.tag(3)
                    ShopListView(root: $rootSection4, selection: $selection).tabItem {
                        Image(systemName: "calendar.badge.clock")
                    }.tag(4)
                    MyPageView(root: $rootSection5, selection: $selection).tabItem {
                        Image(systemName: "person.fill")
                    }.tag(5)
                }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(UserStore())
            .environmentObject(ShopStore())
    }
}
