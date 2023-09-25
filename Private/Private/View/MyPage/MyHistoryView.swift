//
//  MyHistoryView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI

struct MyHistoryView: View {
    @State var isFeed: Bool = true
    @State var isMap: Bool = false
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button(action: {
                    isFeed = true
                    isMap = false
                }, label: {
                    Image(systemName: "line.3.horizontal")
                    Text("피드")
                })
                .font(.pretendardBold24)
                .foregroundColor(isFeed || !isMap ? .white : .white.opacity(0.5))
                
                Spacer()
                
                Button(action: {
                    isFeed = false
                    isMap = true
                }, label: {
                    Image(systemName: "map")
                    Text("지도")
                })
                .font(.pretendardBold24)
                .foregroundColor(isMap ? .white : .white.opacity(0.5))
                .sheet(isPresented: $isMap){
                    NavigationView {
                        MapMainView()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        isMap = false
                                        isFeed = true
                                    }, label: {
                                        Text("취소")
                                            .foregroundColor(.white)
                                    })
                                }
                            }
                    }
                }
                
                Spacer()
            }
            if (isFeed == true || isMap == false) {
                if UserStore.user.myFeed.isEmpty {
                Text("게시물이 존재 하지 않습니다.")
                        .font(.pretendardBold24)
                        .padding()
                } else {
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 1
                    ) {
                         
                            ForEach(UserStore.user.myFeed, id: \.self) { feed in
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
    }
}

struct MyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MyHistoryView()
    }
}
