//
//  MyReservation.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct MyReservation: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var shopStore: ShopStore
    
    /// 각 버튼을 누르면 해당 화면을 보여주는 Int값(0: 이용완료 / 1: 이용예정)
    @State var viewNumber: Int = 0
    @Binding var isShowingMyReservation: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        viewNumber = 0
                    }label: {
                        Text("이용예정")
                            .font(.pretendardRegular16)
                            .foregroundColor(viewNumber == 0 ? .privateColor : .primary)
                            .frame(width: .screenWidth*0.5)
                            .padding(.bottom, 15)
                            .modifier(YellowBottomBorder(showBorder: viewNumber == 0))
                    }
                    Spacer()
                    Button {
                        viewNumber = 1
                    }label: {
                        Text("이용완료")
                            .font(.pretendardRegular16)
                            .foregroundColor(viewNumber == 1 ? .privateColor : .primary)
                            .frame(width: .screenWidth*0.5)
                            .padding(.bottom, 15)
                            .modifier(YellowBottomBorder(showBorder: viewNumber == 1))
                    }
                }
                .padding([.horizontal, .top])
            }
            
            TabView(selection: $viewNumber) {
                AfterUse().tag(0)
                BeforeUse().tag(1)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .navigationTitle("예약내역")
        .navigationBarBackButtonHidden()
        .backButtonArrow()
    }
}

struct MyReservation_Previews: PreviewProvider {
    static var previews: some View {
        MyReservation(isShowingMyReservation: Binding.constant(true))
            .environmentObject(ReservationStore())
            .environmentObject(ShopStore())
    }
}

/// 내 예약 - 이용 후
struct AfterUse: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var shopStore: ShopStore
    @State var viewNumber: Int = 0

    var body: some View {
        VStack {
            if reservationStore.reservationList.filter({ Date() <= $0.date }).isEmpty {
                Spacer()
                Text("예약 내역이 없습니다.")
                    .font(.pretendardMedium20)
                    .foregroundStyle(.primary)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(reservationStore.reservationList.filter { Date() <= $0.date }, id: \.self) { reservation in
                            ReservationCardView(viewNumber: $viewNumber, reservation: reservation)
                            PrivateDivder()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

/// 내 예약 - 이용 예정
struct BeforeUse: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var shopStore: ShopStore
    @State var viewNumber: Int = 1
    
    var body: some View {
        VStack {
            if reservationStore.reservationList.filter ({ Date() > $0.date }).isEmpty {
                Spacer()
                Text("예약 내역이 없습니다.")
                    .font(.pretendardMedium20)
                    .foregroundStyle(.primary)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(reservationStore.reservationList.filter { Date() > $0.date }, id: \.self) { reservation in
                            ReservationCardView(viewNumber: $viewNumber, reservation: reservation)
                            PrivateDivder()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
