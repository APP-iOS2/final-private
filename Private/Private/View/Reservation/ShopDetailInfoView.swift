//
//  ShopDetailInfoView.swift
//  Private
//
//  Created by H on 2023/09/26.
//

import SwiftUI

struct ShopwDetailInfoView: View {
    
    let dummyImage: [URL] = Array(repeating: URL(string: "https://image.bugsm.co.kr/album/images/500/40912/4091237.jpg")!, count: 10)
    let dummyBusinessHours: String = """
    월화 휴무
    14:30 - 18:00 브레이크 타임
    수 12:00 - 20:00
    목 12:00 - 20:00
    금 12:00 - 20:00
    토 12:00 - 20:00
    일 12:00 - 20:00
    """
    let dummyShop = ShopStore.shop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dummyImage, id: \.self) { imageURL in
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .frame(height: 100)
            
            Divider()
            
            Text(dummyShop.shopInfo)
                .font(Font.pretendardRegular16)
            
            Divider()
            
            HStack(spacing: 10) {
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                
                Text("영업 시간")
                    .font(Font.pretendardMedium18)
                
                Spacer()
                
                ZStack {
                    Text("영업 전")
                        .font(Font.pretendardMedium18)
                        .padding(10)
                }
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
            }
            
            VStack(spacing: 0) {
                Text(dummyBusinessHours)
                    .font(Font.pretendardRegular16)
                    .lineSpacing(5)
                    .frame(alignment: .leading)
            }
        }
    }
}


struct ShopDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ShopwDetailInfoView()
    }
}
