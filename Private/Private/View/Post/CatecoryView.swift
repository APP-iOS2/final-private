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
    @State private var myselectedCategory: [MyCategory] = MyCategory.allCases
    @State private var selectedToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    private let maxSelectedCategories = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("카테고리")
                    .font(.pretendardMedium20)
                Text("(최대 3개)")
                    .font(.pretendardRegular12)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: createGridColumns(), spacing: 20) {
                ForEach (Category.allCases.indices, id: \.self) { index in
                    VStack {
                        if selectedToggle[index] {
                            Text(Category.allCases[index].categoryName)
                                .font(.pretendardMedium16)
                                .foregroundColor(.black)
                                .frame(width: 70, height: 30)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                                .background(Color.accentColor)
                                .cornerRadius(7)
                        } else {
                            Text(Category.allCases[index].categoryName)
                                .frame(width: 70, height: 30)
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
                        if selectedCategories.count < maxSelectedCategories || selectedToggle[index] {
                            toggleCategorySelection(at: index)
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
        } // VStack
    } // body
    func toggleCategorySelection(at index: Int) {
        selectedToggle[index].toggle()
        selectedCategories = Set(Category.allCases.indices
            .filter { selectedToggle[$0] }
            .map { Category.allCases[$0] }
        )
    }
    
    func createGridColumns() -> [GridItem] {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
        return columns
    }
}

struct CatecoryView_Previews: PreviewProvider {
    static var previews: some View {
        CatecoryView(selectedCategory: .constant([]))
    }
}
