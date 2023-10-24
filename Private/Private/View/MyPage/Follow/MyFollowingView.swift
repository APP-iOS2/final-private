//
//  MyFollowingView.swift
//  Private
//
//  Created by 주진형 on 2023/10/04.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Kingfisher

struct MyFollowingView: View {
    //@EnvironmentObject var userStore: UserStore
    @EnvironmentObject var followStore: FollowStore
    let user: User
    var followingList: [String]
    @State private var followingUserList: [User] = []
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(followingUserList, id:\.self) { following in
                HStack {
                    NavigationLink() {
                        OtherProfileView(user:following)
                    } label: {
                        if following.profileImageURL.isEmpty {
                            ZStack {
                                Circle()
                                    .frame(width: .screenWidth*0.13)
                                    .foregroundColor(.primary)
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: .screenWidth*0.115,height: .screenWidth*0.115)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                            }
                        } else {
                            KFImage(URL(string: following.profileImageURL))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                        }
                        Text("\(following.nickname)")
                            .font(.pretendardMedium18)
                            .foregroundColor(.primary)
                            .padding(.leading, 15)
                    }
                    Spacer()
                    Button {
                        followStore.unfollow(userId: following.name, myName: user.nickname, userEmail: user.email)
                        followingUserList.removeAll { $0 == following }
                    } label: {
                        Text("언팔로우")
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .font(.pretendardBold14)
                            .foregroundColor(.black)
                            .background(Color.yellow)
                            .cornerRadius(20)
                        
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
                Divider()
                    .background(Color.primary)
                    .frame(width: .screenWidth*0.9)
            }
        }
        .onAppear {
            
            if followingUserList.count != followingList.count {
                searchFollowingUser(searchName: followingList)
            }
        }
        .refreshable {
            followStore.fetchFollowerFollowingList(user.email)
        }
        
    }
    func searchFollowingUser(searchName: [String]) {
        
        for index in searchName {
            let query = userCollection
                .whereField("nickname",isEqualTo: index)
                .limit(to: 10)
            
            query.getDocuments { (querySnapshot,error) in
                if let error = error {
                    print("데이터 가져오기 실패: \(error.localizedDescription)")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let user = User(document: data)
                    followingUserList.append(user ?? User())
                }
            }
        }
    }
}

struct MyFollowingView_Previews: PreviewProvider {
    static var previews: some View {
        MyFollowingView(user: User(),followingList: [""]).environmentObject(UserStore())
    }
}
