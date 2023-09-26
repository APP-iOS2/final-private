//
//  CatecoryView.swift
//  Private
//
//  Created by 최세근 on 2023/09/22.
//

import SwiftUI

struct CatecoryView: View {
    
    @State private var selectedCategory: Category = .koreanFood
    private let gridItems: [GridItem] = [
        GridItem(.adaptive(minimum: 70))
        //        .init(.flexible(), spacing: 10),
        //        .init(.flexible(), spacing: 10),
        //        .init(.flexible(), spacing: 10),
        //        .init(.flexible(), spacing: 10),
        //        .init(.flexible(), spacing: 10)
    ]
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("카테고리")
                    .font(.title2).fontWeight(.semibold)
                Text("(최대3개)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: gridItems) {
                ForEach (Category.allCases, id: \.rawValue) { category in
                    VStack {
                        if category == selectedCategory {
                            Text(category.categoryName)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.vertical,4)
                                .padding(.horizontal, 4)
                                .background(Color.accentColor)
                                .cornerRadius(7)
                            
                            
                        } else {
                            Text(category.categoryName)
                                .padding(.vertical,4)
                                .padding(.horizontal, 4)
                                .cornerRadius(7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.darkGrayColor, lineWidth: 1.5)
                                    //                                        .frame(width: 70, height: 28)
                                )
                        }
                    }
                    .onTapGesture {
                        self.selectedCategory = category
                        print(self.selectedCategory)
                    }
                }
            }
        }
    }
}


struct CatecoryView_Previews: PreviewProvider {
    static var previews: some View {
        CatecoryView()
    }
}
