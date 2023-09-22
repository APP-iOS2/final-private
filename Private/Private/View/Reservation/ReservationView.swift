//
//  ReservationView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct ReservationView: View {
    
    @ObservedObject var shopStore: ShopStore
    
    @State private var showingDate: Bool = false
    @State private var showingNumbers: Bool = false
    @State private var number = 1  // 인원
    private let step = 1
    private let range = 1...6  // 인원제한에 대한 정보가 없음
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .opacity(0)
                
                // 메뉴마다 이렇게 있을 수 없음.. 식당에서는 예약 아이템을 어떻게 둬야할지
                ItemInfoView(shopStore: shopStore)
                    .padding(.bottom, 20)
                
                Text("예약 일시")
                    .font(Font.pretendardBold24)
                
                // 버튼의 범위를 HStack 전체로 할지 고민
                HStack {
                    Image(systemName: "calendar")
                    Text("오늘(수) / 시간")
                    Spacer()
                    Button {
                        showingDate.toggle()
                    } label: {
                        Image(systemName: showingDate ? "chevron.up.circle": "chevron.down.circle")
                    }
                }
                .font(Font.pretendardMedium18)
                .padding()
                .background(Color("SubGrayColor"))
                .padding(.bottom)
                .onTapGesture {
                    showingDate.toggle()
                }
                
                // 예약 클릭 시 뷰가 새로 뜨게함
                
                Text("인원")
                    .font(Font.pretendardBold24)
                
                HStack {
                    Image(systemName: "person")
                    Text("인원 선택")
                    Spacer()
                    Button {
                        showingNumbers.toggle()
                    } label: {
                        Image(systemName: showingNumbers ? "chevron.up.circle": "chevron.down.circle")
                    }
                }
                .font(Font.pretendardMedium18)
                .padding()
                .background(Color("SubGrayColor"))
                .padding(.bottom, 20)
                .onTapGesture {
                    showingNumbers.toggle()
                }
                
                // 뷰 따로 빼야함
                // 가게 예약 가능인원 정보를 받을지 말지 정해야함
                if showingNumbers {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("1~6명 까지 선택 가능합니다.")
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("방문하시는 인원을 선택하세요")
                        Spacer()

                        // Stepper 안에 숫자를 넣어야 함
                        Stepper(value: $number, in: range, step: step) {
                            Text("\(number)")
                        }
                        .padding(10)
                        
                    }
                }
                
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    HStack {
                        Image(systemName: "info.circle")
                        Text("알립니다")
                    }
                    .font(Font.pretendardBold18)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.bottom, 6)
                    
                    // BreakTime에 대한 Data 없음
                    Text("Break Time")
                    Text("월~금: 15:00 ~ 17:00")
                    Text("토~일: 15:00 ~ 17:00")
                    Text("당일 예약은 예약을 받지 않습니다.\n예약시간은 10분 경과시, 자동 취소됩니다.\n양해부탁드립니다.")
                }
                .padding()
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
                .padding(.bottom, 30)
                
                Button {
                    // 예약하기 뷰로 넘어가기
                } label: {
                    Text("예약하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .tint(.black)
                .background(Color("AccentColor"))
                .cornerRadius(12)
                
            }// VStack
        }// ScrollView
        .padding()
        
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(shopStore: ShopStore(), root: .constant(true), selection: .constant(4))
    }
}
