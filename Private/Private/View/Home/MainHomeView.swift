//
//  MainHomeView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct MainHomeView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State var selectedNumber: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectedNumber = 0
                } label: {
                    Image(systemName: "map")
                    Text("지도")
                }
                .foregroundColor(selectedNumber == 0 ? .primary : .subGrayColor)
                .padding(.bottom, 10)
                .modifier(BottomBorder(showBorder: selectedNumber == 0))
                
                Button {
                    selectedNumber = 1
                } label: {
                    Image(systemName: "text.justify")
                    Text("피드")
                }
                .foregroundColor(selectedNumber == 1 ? .primary : .subGrayColor)
                .padding(.bottom, 10)
                .modifier(BottomBorder(showBorder: selectedNumber == 1))
                
                Spacer()
                
                Button {
                    print("검색")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                NavigationLink {
                    ChatRoomListView()
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding(.leading, 10)
            .padding(.horizontal, 10)
            .font(.pretendardMedium20)
            .foregroundColor(.primary)
            
            if selectedNumber == 0 {
                MapMainView()
            } else if selectedNumber == 1 {
                FeedMainView()
            }
        }
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeView(root: .constant(true), selection: .constant(1))
            .environmentObject(FeedStore())
    }
}
