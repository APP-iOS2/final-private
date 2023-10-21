//
//  MyReservation.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct MyReservation: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var shopStore: ShopStore
    
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var viewNumber: Int = 0
    
    @Binding var isShowingMyReservation: Bool
    
    var body: some View {
        NavigationStack {
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
            .padding()
            
            if reservationStore.reservationList.isEmpty {
                VStack {
                    Spacer()
                    Text("예약 내역이 없습니다.")
                        .font(.pretendardMedium20)
                        .foregroundStyle(.primary)
                    Spacer()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if viewNumber == 0 {
                            VStack(alignment: .leading) {
                                Divider()
                                    .opacity(0)
                                HStack {
                                    Image(systemName: "info.circle")
                                    Text("알립니다")
                                }
                                .font(.pretendardBold18)
                                .foregroundColor(Color.privateColor)
                                .padding(.bottom, 6)
                                
                                Text("예약 변경 및 취소는 예약시간 한 시간 전까지 가능합니다")
                                .font(.pretendardRegular16)
                                .foregroundStyle(Color.primary)
                            }
                            .padding()
                            .background(Color.subGrayColor)
                            .cornerRadius(12)
                            .padding(.bottom)
                        }
                        ForEach(viewNumber == 0 ? reservationStore.reservationList.filter { Date() <= $0.date } : reservationStore.reservationList.filter { Date() > $0.date }, id: \.self) { reservation in
                            ReservationCardView(viewNumber: $viewNumber, reservation: reservation)
                                .padding(.bottom, 12)
                        }
                    }
                    .padding()
                }
            }
//                .navigationTitle(
//                    if colorScheme == .dark {
//                        Image("private_dark")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: .screenWidth * 0.35)
//                    } else {
//                        Image("private_light")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: .screenWidth * 0.35)
//                    }
//                )
        }
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
