//
//  ReviewSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//

import SwiftUI
import NMapsMap

struct ReviewSheetView: View {
    var feeds: [Feed]
    
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
                        } //이미지
                    }
                }
            }
        }
        .navigationBarTitle("팔로워의 리뷰", displayMode: .inline)
    }
}
struct ReviewSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSheetView(
            feeds: [
                Feed(writer: User(name: "@Chadul",
                                  nickname: "맛집조아",
                                  phoneNumber: "010-1111-1111",
                                  profileImageURL: "mapuser2",
                                  follower: [],
                                  following: [],
                                  myFeed: [],
                                  savedFeed: [],
                                  bookmark: [],
                                  chattingRoom: [],
                                  myReservation: []),
                     images: ["alla3"],
                     contents:
                        "오늘 여친이랑 같이 갔어요. 여친 생일이라 큰맘 먹었는데 , 플레이팅 너무 감동적이었어요                                                                                                      근데 계산할땐 감동이아니라 슬펐어요.",
                     visitedShop: Shop.init(
                        name: "알라프리마",
                        category: Category.westernFood,
                        coord: NMGLatLng(lat: 127.026033, lng: 37.513526),
                        address: "서울 강남구 학동로17길 13 인본",
                        addressDetail: "논현동 42-6",
                        shopTelNumber: "02-511-2555",
                        shopInfo: "늘 과감하고 창의적인 요리로 미식가들의 발길을 유혹하는 알라 프리마. 오픈된 주방이 한눈에 들어오는 넓은 카운터 테이블과 쾌적한 다이닝 홀, 그리고 프라이빗 다이닝 공간이 모던하게 펼쳐진다. 재료를 생명으로 여기는 김진혁 셰프의 요리는 깔끔한 소스, 맛의 밸런스, 그리고 계절 식재료들의 향연이라 할 수 있다. 와인뿐만 아니라 사케와도 잘 어울리는 이 곳의 모던 퀴진을 경험하려면 예약은 필수다.",
                        shopImageURL: "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/8a8bef0610f647a78854786aae405fa5?w=53&org_if_sml=1",
                        shopItems: [],
                        numberOfBookmark: 0),
                     category: [Category.westernFood]),
                Feed(writer: User(name: "@glahemm",
                                  nickname: "개발자아님",
                                  phoneNumber: "010-1112-1112",
                                  profileImageURL: "mapuser1",
                                  follower: [],
                                  following: [],
                                  myFeed: [],
                                  savedFeed: [],
                                  bookmark: [],
                                  chattingRoom: [],
                                  myReservation: []),
                     images: ["mingle1"],
                     contents:
                        " 탄력근무제라 10시에 출근할 계획, 간단한 식사, '월급여 9,733,960원'...집에 도착해 와인한잔과 함께 프라이빗 접속",
                     visitedShop: Shop.init(
                        name: "밍글스",
                        category: Category.westernFood,
                        coord: NMGLatLng(lat: 127.044128, lng: 37.525373),
                        address: "서울 강남구 도산대로67길 19 힐탑빌딩 2층",
                        addressDetail: "청담동 94-6",
                        shopTelNumber: "02-515-7306",
                        shopInfo: "따뜻한 여백의 미가 돋보이는 밍글스. 실내 디자인, 한국 음식의 정갈한 멋을 한층 더 살려 주는 도예 기물, 여기에 주방을 이끄는 강민구 셰프의 젊고 감각적인 재능까지, 다양한 전문가들의 감각과 감성이 하나의 공간에 모여 있다. 초창기부터 뚜렷한 한국적 색채를 기반으로 전통과 현대의 경계를 자유롭게 넘나들며 밍글스만의 맛과 멋을 창조해온 강민구 셰프는 새로운 공간에서 한 걸음 더 진화된 요리를 선보인다. 밍글스만의 독특한 매력은 전복 배추선과 어만두처럼 경계를 허무는 요리에서 정점을 이룬다. 김민성 매니저가 이끄는 서비스 팀의 배려 깊은 고객 응대 역시 레스토랑의 가치를 한층 더 높여 준다.",
                        shopImageURL: "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/b1998f42d3b642d2bf04ac9156783877?w=53&org_if_sml=1",
                        shopItems: [],
                        numberOfBookmark: 0),
                     category: [Category.westernFood]),
                
                Feed(writer: User(name: "@MichelleM",
                                  nickname: "배고픈미쳴",
                                  phoneNumber: "010-1113-1113",
                                  profileImageURL: "mapuser3",///
                                  follower: [],
                                  following: [],
                                  myFeed: [],
                                  savedFeed: [],
                                  bookmark: [],
                                  chattingRoom: [],
                                  myReservation: []),
                     images: ["jung2"],
                     contents:
                        " 훌륭하고 감각적인 다이닝입니다. 제 삶과 맞대어 있는 소중한 장소. 계절에 맞는 신선하고 창의적인 디쉬 구성. 사랑하지 않을 이유가 없습니다.",
                     visitedShop: Shop.init(
                        name: "정식당",
                        category: Category.koreanFood,
                        coord: NMGLatLng(lat: 127.041072, lng: 37.525656),
                        address: "서울 강남구 선릉로158길 11",
                        addressDetail: "청담동 83-24",
                        shopTelNumber: "02-517-4654",
                        shopInfo: "모던 한식 파인 다이닝을 개척한 장본인이라 평가받는 임정식 셰프는 자신의 이름을 내건 정식당 서울과 정식당 뉴욕을 통해 새롭고 창의적인 한식을 세계에 알리고 있다. 김밥, 비빔밥, 구절판, 보쌈 등 대중들이 친근하게 여기는 다양한 한식 요리에서 영감을 얻어 재해석한 독창적인 메뉴는 한국인에게 익숙한 맛을 기발하게 풀어내는 방식으로 한식의 맛과 멋을 동시에 만족시킨다. 독특한 디저트와 훌륭한 구성의 와인 리스트, 그리고 배려심 깊은 서비스 등 즐거운 식사를 위한 요소들이 두루 갖춰진 곳이다.",
                        shopImageURL: "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/d479e72dae4d4bb48884154dcd612906?w=53&org_if_sml=1",
                        shopItems: [],
                        numberOfBookmark: 0),
                     category: [Category.koreanFood]),
                
                Feed(writer: User(name: "@LikaLike",
                                  nickname: "SigRxPP",
                                  phoneNumber: "010-1114-1114",
                                  profileImageURL: "mapuser4",
                                  follower: [],
                                  following: [],
                                  myFeed: [],
                                  savedFeed: [],
                                  bookmark: [],
                                  chattingRoom: [],
                                  myReservation: []),
                     images: ["kwon2"],
                     contents:
                        " 콩국수는 정말 별미네요.자주는 못 가도 부모님은 한 번 모시고 가고 싶네요. 즐거운 경험이었습니다~",
                     visitedShop: Shop.init(
                        name: "권숙수",
                        category: Category.koreanFood,
                        coord: NMGLatLng(lat: 127.043581, lng: 37.524391),
                        address: "서울 강남구 압구정로80길 37 이에스 빌딩 4층",
                        addressDetail: "청담동 92-18",
                        shopTelNumber: "0507-1354-6268",
                        shopInfo: "‘전문 조리사’를 뜻하는 ‘숙수’에서 착안해 이름 지은 ‘권숙수’는 권우중 셰프의 한식 레스토랑이다. 이곳에선 한식의 기본 맛을 좌우하는 장, 젓갈, 식초 등을 직접 담가 사용하는데, 이러한 정성이 권숙수만의 기품 있는 요리를 완성한다. 제철 식재료 중에서도 좀 더 진귀한 재료를 선별하고, 흔한 식재료일지라도 창의적인 조합을 통해 새로운 요리로 탄생시키는 권 셰프의 노력과 열정을 곳곳에서 발견할 수 있다. 좋은 음식을 위해서라면 일절 타협하지 않는 ‘숙수’의 고집이 고스란히 녹아 있는 이곳에서 한식의 깊은 맛을 느껴보길.",
                        shopImageURL: "https://axwwgrkdco.cloudimg.io/v7/__gmpics__/9f989cdd50ea42fb8f3c7cbe31c79465?w=53&org_if_sml=1",
                        shopItems: [],
                        numberOfBookmark: 0),
                     category: [Category.koreanFood]),
                
            ]
        )
    }
}
