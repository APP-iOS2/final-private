//
//  OtherSavedView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI

struct OtherSavedView: View {
    
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    let user: User
    
    var body: some View {
        ScrollView {
            if user.savedFeed.isEmpty {
                Text("저장한 피드가 없습니다")
                    .font(.pretendardBold24)
                    .padding(.top, .screenHeight * 0.2)
            } else {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 1
                ) {
                    ForEach(user.savedFeed, id: \.self) { feed in
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

struct OtherSavedView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSavedView(user: User())
    }
}

