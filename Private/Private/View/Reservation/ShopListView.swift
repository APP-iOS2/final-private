//
//  ShopListView.swift
//  Private
//
//  Created by 박성훈 on 10/11/23.
//

import SwiftUI
import Kingfisher

struct ShopListView: View {
    @EnvironmentObject var shopStore: ShopStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        List {
            ForEach(shopStore.shopList, id: \.self) { shopData in
                NavigationLink {
                    ShopDetailView(shopData: shopData)
                } label: {
                    HStack(alignment: .top){
                        KFImage(URL(string: shopData.shopImageURL)!)
                                        .onFailure({ error in
                                            print("Error : \(error)")
                                        })
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text("\(shopData.category.categoryName)")
                            Text(shopData.name)
                        }
                    }
                    
                }
            }
        }
    }
}

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView(root: .constant(true), selection: .constant(4))
            .environmentObject(ShopStore())
    }
}
