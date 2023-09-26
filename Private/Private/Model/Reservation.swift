//
//  Reservation.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

// 1. 통으로 넣는다 - 용량차지(트래픽)
// 2. id만 넣어서, 나중에 해당 데이터를 조회해서 사용한다. - 따로 조회시켜야 함
// 3. 필요한 데이터를 프로퍼티로 만들어서 따로 넣는다. - 프로퍼티가 많아짐 (편법느낌) 조회 안하고 바로 심어버리겠다.

struct Reservation {
    var id: String = UUID().uuidString
    var shop: Shop    // bottles에서는 ShopId로 퉁쳤다..
    var reservedUser: User   // 예약자(UserId) (필요한 정보만 담아서)
    var date: Double  // 예약일
    var time: String  // 예약시간
    var numberOfPeople: Int  // 예약인원
    var totalPrice: Double   // 총 가격
    var requirement: String? // 요구사항

    /*
     mySQL 등을 활용할 때는 id만 올려도 됨 - 하나의 정보를 얻을 때 조회를 하면 됨(관계형 데이터베이스)
     지금 하는 건 도큐먼트 데이터베이스(NOSQL) - 조회를 할 때마다 샵 컬렉션에서 물어봐서 가져와야 함(매번 가져와야 함)
     
     Firebase 공식자료 참고 - 한 번에 가져와야 할 대상이 있다면 서브데이터로 중복되어도 괜찮으니 심어버려라!!
     NOSQL 기본 개념임
     그 중 도큐먼트 데이터베이스인 firebase
     
     관계형 베이스와 NOSQL의 차이를 인지하고 사용할 것
     
     조회를 적게 차지하냐 vs. 용량을 많이 차지하냐(트래픽과도 관련이 있음)
     콘솔에 일단 데이터를 심어보자
     */
}
