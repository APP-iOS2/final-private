//
//  ReservationCardView.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct ReservationCardView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
    @State private var isShowDeleteMyReservationAlert: Bool = false
    @State private var isShowRemoveReservationAlert: Bool = false
    @State private var isShowModifyView: Bool = false
    
    var reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(reservationStore.isFinishedReservation(date: reservation.date, time: reservation.time))
                    .font(.pretendardMedium20)
                
                Spacer()
                Menu {
                    Button {
                        print(#fileID, #function, #line, "- 가게보기")
                    } label: {
                        Text("가게보기")
                    }
                    
                    Button {
                        print(#fileID, #function, #line, "- 예약 상세내역 보기")
                    } label: {
                        Text("예약상세")
                    }
                    
                    Button(role: .destructive) {
                        print(#fileID, #function, #line, "- 예약내역 삭제")
                        isShowDeleteMyReservationAlert.toggle()
                    } label: {
                        Text("예약내역 삭제")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(20)  // 버튼 터치 영역을 넓히기 위함
                }
                .foregroundColor(Color.secondary)
            }
            
            ReservationCardCell(title: "예약 날짜", content: dateToFullString(date: reservation.date))
            ReservationCardCell(title: "예약 시간", content: "\(reservation.time)시")
            ReservationCardCell(title: "예약 인원", content: "\(reservation.numberOfPeople)명")
            ReservationCardCell(title: "총 비용", content: "\(reservation.totalPrice)원")
            
            
            Button {
                print(#fileID, #function, #line, "- 예약 변경하기 ")
                isShowModifyView.toggle()  // 여기서부터가 문제넹 찾아보자
            } label: {
                Text("예약 변경")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color("AccentColor"))
            .cornerRadius(12)
            
            Button {  // navigationLink로 해도 될듯
                print(#fileID, #function, #line, "- 예약 취소하기 ")
                isShowRemoveReservationAlert.toggle()
            } label: {
                Text("예약 취소")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color("AccentColor"))
            .cornerRadius(12)
        }
        .padding()
        .background(Color("SubGrayColor"))
        .cornerRadius(12)
        .navigationDestination(isPresented: $isShowModifyView, destination: {
            ModifyReservationView(isShowModifyView: $isShowModifyView, reservationData: reservation)
        })
        .alert("예약 내역 삭제", isPresented: $isShowDeleteMyReservationAlert) {
            Button(role: .destructive) {
                reservationStore.deleteMyReservation(reservation: reservation)
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
                reservationStore.removeReservation(reservation: reservation)
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
        //        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.locale = Locale(identifier: "ko_KR")
        //        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct ReservationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCardView(reservation: ReservationStore.tempReservation)
            .environmentObject(ReservationStore())
    }
}

struct ReservationCardCell: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("\(title)")
                .font(Font.pretendardMedium18)
            
            Spacer()
            
            Text("\(content)")
                .font(Font.pretendardMedium16)
        }
    }
}
