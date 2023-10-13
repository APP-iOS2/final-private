//
//  EmptyFeed.swift
//  Private
//
//  Created by yeon on 10/10/23.
//

import SwiftUI
struct EmptyFeed: View {
    enum FeedType {
        case noFollowing
        case noFeed
    }
    
    var feedType: FeedType
    
    var body: some View {
//        VStack(spacing: 20) {
        VStack {
            Spacer()
            if feedType == .noFollowing {
              
                Text("팔로잉 목록이 없습니다.")
                
                    .font(.title)
                    .foregroundColor(.gray)
                
                Text("새로운 친구를 팔로잉하러 가보세요!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: SearchView(root: .constant(true), selection: .constant(0))) {
                    Text("팔로잉하러 가기")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else if feedType == .noFeed {
                Text("피드가 없습니다.")
                    .font(.title)
                    .foregroundColor(.gray)
                
                Text("친구들의 피드를 확인하려면 팔로잉하세요!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                NavigationLink(destination: SearchView(root: .constant(true), selection: .constant(0))) {
                    Text("팔로잉하러 가기")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            //.padding()
        }
    }
}
struct EmptyFeed_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyFeed(feedType: .noFollowing)
        }
    }
}
