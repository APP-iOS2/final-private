//
//  FeedUpdateCateroryView.swift
//  Private
//
//  Created by yeon I on 10/19/23.
//

import SwiftUI

struct FeedUpdateCateroryView: View {
    
    @State  var updatedCategory: [String] = []
    @State  var toUpdateCategories: Set<Category> = []
    @State  var showUpdateAlert = false
    @State  var myselectedtoupdateCategory: [MyCategory] = MyCategory.allCases
    @State  var selectedUpdateToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
     let maxSelectedToUpdateCategories = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("카테고리")
                    .font(.pretendardMedium20)
                Text("(최대 3개)")
                    .font(.pretendardRegular12)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: createGridUpdateColumns(), spacing: 20) {
                ForEach (Category.allCases.indices, id: \.self) { index in
                    VStack {
                        if selectedUpdateToggle[index] {
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
                        if toUpdateCategories.count < maxSelectedToUpdateCategories || selectedUpdateToggle[index] {
                            toggleCategoryUpdateSelection(at: index)
                            print(toUpdateCategories)
                        } else {
                            showUpdateAlert = true
                            print("3개 초과 선택")
                        }
                    }
                    .alert(isPresented: $showUpdateAlert) {
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
    func toggleCategoryUpdateSelection(at index: Int) {
        selectedUpdateToggle[index].toggle()
        toUpdateCategories = Set(Category.allCases.indices
            .filter { selectedUpdateToggle[$0] }
            .map { Category.allCases[$0] }
        )
    }
    
    func createGridUpdateColumns() -> [GridItem] {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
        return columns
    }
}
