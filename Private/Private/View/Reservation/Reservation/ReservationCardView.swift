//
//  ReservationCardView.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI
import Kingfisher

struct ReservationCardView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var shopStore: ShopStore
    
    @State private var isShowDeleteMyReservationAlert: Bool = false
    @State private var isShowRemoveReservationAlert: Bool = false
    @State private var isShowModifyView: Bool = false
    @State private var disableReservationButton: Bool = false
    @State private var reservationState: String = ""
    
    @State private var shopData: Shop = ShopStore.shop
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    @State private var reservedDate: String = ""

    private let currentDate = Date()
    var reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(reservationState)
                    .font(.pretendardMedium20)
                
                Spacer()
                Menu {
                    NavigationLink {
                        ShopDetailView(shopViewModel: ShopViewModel(shop: shopData, userID: userStore.user.id))
                    } label: {
                        Text("가게보기")
                    }
                    
                    NavigationLink {
                        ReservationConfirmView(reservationData: temporaryReservation, shopData: shopData)
                    } label: {
                        Text("예약상세")
                    }
                    
                    if disableReservationButton {
                        Button(role: .destructive) {
                            print(#fileID, #function, #line, "- 예약내역 삭제")
                            isShowDeleteMyReservationAlert.toggle()
                        } label: {
                            Text("예약내역 삭제")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 25, height: 20)
                }
                
                .foregroundColor(Color.secondary)
            }
            
            HStack {
                Text(reservedDate)
                Text("\(temporaryReservation.time)시")
            }
            HStack(alignment: .top) {
                KFImage(URL(string: shopData.shopImageURL)!)
                    .placeholder({
                        ProgressView()
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .padding(.trailing, 2)
                
                VStack(alignment: .leading) {
                    Text(shopData.name)
                        .font(.pretendardBold20)
                        .padding(.bottom, 6)
                    
//                    ReservationCardCell(title: "예약 날짜", content: dateToFullString(date: temporaryReservation.date))
//                    ReservationCardCell(title: "예약 시간", content: "\(temporaryReservation.time)시")
                    ReservationCardCell(title: "예약 인원", content: "\(temporaryReservation.numberOfPeople)명")
                }
            }
            
//            ReservationCardCell(title: "예약 날짜", content: dateToFullString(date: temporaryReservation.date))
//            ReservationCardCell(title: "예약 시간", content: "\(temporaryReservation.time)시")
//            ReservationCardCell(title: "예약 인원", content: "\(temporaryReservation.numberOfPeople)명")
            //ReservationCardCell(title: "총 비용", content: "\(temporaryReservation.totalPrice)원")
                .padding(.bottom)
            
            HStack {
                ReservationButton(text: "예약 변경") {
                    isShowModifyView.toggle()
                }
                .foregroundStyle(disableReservationButton ? Color.gray : .black)
                .disabled(disableReservationButton)
                
                ReservationButton(text: "예약 취소") {
                    isShowRemoveReservationAlert.toggle()
                }
                .foregroundStyle(disableReservationButton ? Color.gray : .black)
                .disabled(disableReservationButton)
            }
        }
        .padding()
        .background(Color("SubGrayColor"))
        .cornerRadius(12)
        .onAppear {
            self.temporaryReservation = self.reservation
            self.reservedDate = reservationStore.getReservationDate(reservationDate: self.temporaryReservation.date)
            self.reservationState = reservationStore.isFinishedReservation(date: temporaryReservation.date, time: temporaryReservation.time)
            
            // 현재시간과 예약시간이 1시간 이내이면 disable
            let changeableTime = temporaryReservation.date.addingTimeInterval(-3600) // 예약시간 -1시간
            if changeableTime <= currentDate {
                disableReservationButton = true
            }
            
            self.shopData = shopStore.getReservedShop(reservationData: self.reservation)
        }
        .navigationDestination(isPresented: $isShowModifyView, destination: {
            ModifyReservationView(temporaryReservation: $temporaryReservation, isShowModifyView: $isShowModifyView, shopData: shopData)
        })
        .alert("예약 내역 삭제", isPresented: $isShowDeleteMyReservationAlert) {
            Button(role: .destructive) {
                reservationStore.deleteMyReservation(reservation: temporaryReservation)
            } label: {
                Text("삭제하기")
            }
            Button(role: .cancel) {
                
            } label: {
                Text("돌아가기")
            }
            .foregroundStyle(Color.red)
        }
        .alert("예약 취소", isPresented: $isShowRemoveReservationAlert) {
            Button(role: .destructive) {
                reservationStore.removeReservation(reservation: temporaryReservation)
            } label: {
                Text("취소하기")
            }
            Button(role: .cancel) {
                
            } label: {
                Text("돌아가기")
            }
            .foregroundStyle(Color.red)
        }
    }
    
    func dateToFullString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct ReservationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCardView(reservation: ReservationStore.tempReservation)
            .environmentObject(ReservationStore())
            .environmentObject(ShopStore())
    }
}

struct ReservationCardCell: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("\(title)")
                .font(.pretendardMedium18)
            
            Spacer()
            
            Text("\(content)")
                .font(.pretendardMedium16)
        }
        .padding(.bottom, 1)
    }
}
