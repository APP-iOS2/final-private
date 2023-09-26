//
//  MapReviewRowView.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//

import SwiftUI
struct MapReviewRowView: View {
    var feed: Feed
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(feed.images, id: \.self) { imageName in
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(feed.writer.profileImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
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
                            .frame(width:130, height: 130)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(10)
                    }
                    VStack(alignment: .leading ) {
                        Text(feed.contents)
                            .font(.pretendardRegular14)
                            .padding(.leading ,10)
                            .lineSpacing(3)
                            .padding(.bottom, 15)
                        VStack(alignment: .leading ) {
                            HStack {
                                Spacer()
                                Button {
                                    //ChatRoomView()
                                } label: {
                                    Image(systemName: "paperplane")
                                        .font(.pretendardRegular14)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.darkGrayColor)
                                        .cornerRadius(30)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
struct MapReviewRowView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(dummyFeeds, id: \.id) { feed in
            MapReviewRowView(feed: feed)
        }
    }
}
