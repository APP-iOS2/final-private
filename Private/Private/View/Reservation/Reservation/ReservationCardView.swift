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
    @State private var disableReservationButton: Bool = false
    @State private var isCancelReservation: Bool = false
    @State private var reservationState: String = ""
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    @State private var shopData: Shop = ShopStore.shop
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    @State private var reservedDate: String = ""
    
    @Binding var useCompleted: Bool
    
    private let currentDate = Date()
    var reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(reservedDate)
                    .font(.pretendardMedium16)
                Text(self.reservedTime + " \(self.reservedHour)시")
                    .font(.pretendardMedium16)
                Spacer()
                Menu {
                    NavigationLink {
                        ShopDetailView(shop: shopData)
                    } label: {
                        Text("가게보기")
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
            .padding(.bottom, 8)
            
     
            NavigationLink {
                ReservationConfirmView(useCompleted: $useCompleted, reservationData: temporaryReservation, shopData: shopData)
            } label: {
                HStack(alignment: .top) {
                    KFImage(URL(string: shopData.shopImageURL)!)
                        .placeholder({
                            ProgressView()
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .padding(.trailing, 2)
                    
                    VStack(alignment: .leading) {
                            Text(shopData.name)
                                .font(.pretendardMedium20)
                                .foregroundStyle(Color.primary)
                                .padding(.bottom, 6)
                        ReservationCardCell(title: "예약 인원", content: "\(temporaryReservation.numberOfPeople)명")
                        ReservationCardCell(title: "결제 금액", content: "\(temporaryReservation.priceStr)")
                    }
                }
            }
            .simultaneousGesture(TapGesture().onEnded{
                isCancelReservation.toggle()
            })
        }
        .padding(.horizontal)
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
            
            reservedTime = reservationStore.conversionReservedTime(time: temporaryReservation.time).0
            reservedHour = reservationStore.conversionReservedTime(time: temporaryReservation.time).1
        }
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
        } message: {
            Text("예약 내역을 삭제하시겠습니까?")
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
        } message: {
            Text("예약을 취소하시겠습니까?")
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
        ReservationCardView(useCompleted: .constant(false), reservation: ReservationStore.tempReservation)
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
            Spacer()
            Text("\(content)")
        }
        .font(.pretendardMedium18)
        .foregroundStyle(Color.primary)
        .padding(.bottom, 1)
    }
}
