//
//  MySavedView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI

struct MySavedView: View {
    
    @EnvironmentObject var userStore: UserStore
    
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    var body: some View {
        if userStore.user.savedFeed.isEmpty {
            Text("저장한 피드가 없습니다")
                .font(.pretendardBold24)
                .padding()
        } else {
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 1
                ) {
                    ForEach(userStore.user.savedFeed, id: \.self) { feed in
                        AsyncImage(url:URL(string:feed.images[0])) { image in
                            image
                                .resizable()
                                .frame(width: .screenWidth*0.95*0.3 ,height: .screenWidth*0.95*0.3)
                            
                        } placeholder: {
                            Image(systemName: "photo")
                        }
                    }
                }
            }
        }
    }
}

struct MySavedView_Previews: PreviewProvider {
    static var previews: some View {
        MySavedView()
    }
}
