//
//  CatecoryView.swift
//  Private
//
//  Created by 최세근 on 2023/09/22.
//

import SwiftUI

struct CatecoryView: View {
    
    @Binding var selectedCategory: [String]
    @State private var selectedCategories: Set<Category> = []
    @State private var showAlert = false

    private let maxSelectedCategories = 3
    
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
                Text("(최대 3개)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: gridItems) {
                ForEach (Category.allCases, id: \.rawValue) { category in
                    VStack {
                        if selectedCategories.contains(category) {
                            Text(category.categoryName)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                                .background(Color.accentColor)
                                .cornerRadius(7)
                        } else {
                            Text(category.categoryName)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                                .cornerRadius(7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.darkGrayColor, lineWidth: 1.5)
                                )
                        }
                    }
                    .onTapGesture {
                        if selectedCategories.count < maxSelectedCategories || selectedCategories.contains(category) {
                            toggleCategorySelection(category)
                            print(selectedCategories)
                        } else {
                            showAlert = true
                            print("3개 초과 선택")
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("선택 초과"),
                            message: Text("최대 3개까지 선택 가능합니다."),
                            dismissButton: .default(Text("확인"))
                        )
                    }

                }
            }
        }
    }
    
    private func toggleCategorySelection(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}



struct CatecoryView_Previews: PreviewProvider {
    static var previews: some View {
        CatecoryView(selectedCategory: .constant([]))
    }
}
