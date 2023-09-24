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
        NavigationStack {
            HStack {
                Button {
                    selectedNumber = 0
                } label: {
                    Image(systemName: "map")
                    Text("지도")
                }
                .padding(.leading, 10)
                
                Button {
                    selectedNumber = 1
                } label: {
                    Image(systemName: "text.justify")
                    Text("피드")
                }
                Spacer()
                
                Button {
                    print("검색")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                NavigationLink {
                    
                } label: {
                    Image(systemName: "paperplane")
                }
            }
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
    }
}
