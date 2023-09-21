//
//  MainTabView.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI

struct MainTabView: View {
    
    @State var selection: Int = 1
    @State private var rootSection1: Bool = false
    @State private var rootSection2: Bool = false
    @State private var rootSection3: Bool = false
    @State private var rootSection4: Bool = false
    
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
            self.selection = $0
        }
    )}
    
    var body: some View {
        Text("메인 탭 뷰")
//        TabView(selection: selectionBinding) {
//            FirstView(root: $rootSection1).tabItem {
//                Image(selection == 1 ? "Maptabfill" : "Map_tab")
//                Text("첫번째 탭")
//            }.tag(1)
//            SecondView(root: $rootSection2).tabItem {
//                Image(selection == 2 ? "BookMark_tab_fill" : "BookMark_tab")
//                Text("두번째 탭")
//            }.tag(2)
//            ThirdView(root: $rootSection3).tabItem {
//                Image(selection == 3 ? "Notification_tab_fill" : "Notification_tab")
//                Text("세번째 탭")
//            }.tag(3)
//            FourthView(root: $rootSection4, selection: $selection).tabItem {
//                Image(selection == 4 ? "MyPage_tab_fill" : "MyPage_tab")
//                Text("네번째 탭")
//            }.tag(4)
//        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
