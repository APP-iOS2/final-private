//
//  ReviewSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI
import NMapsMap

struct ReviewSheetView: View {
    //var feeds: [Feed]
    var feeds: [Feed] = dummyFeeds
    var body: some View {
        NavigationView {
            HStack{
                //6줄 (사진크기에 맞게 6줄 이상은 잘라줘.)
                List(feeds, id: \.id) { feed in
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(feed.images, id: \.self) { imageName in
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(feed.writer.profileImageURL)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 70)
                                        .clipShape(Circle())
                                }
                                VStack {
                                    Text(feed.writer.nickname).font(.pretendardBold18)
                                    Text(feed.writer.name).font(.pretendardRegular14)
                                }
                            }
                            HStack{
                                VStack{
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:130, height: 130 )
                                  
                                } .cornerRadius(10)
                                VStack(alignment: .leading ) {
                                    Text(feed.contents).font(.pretendardRegular14)
                                        .padding(.top, 10)
                                        .lineSpacing(3)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("팔로워의 리뷰", displayMode: .inline)
    }
}
struct ReviewSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSheetView()
            .previewDevice("iPhone 14") // 원하는 디바이스를 지정할 수 있습니다.
    }
}
