//
//  CatecoryView.swift
//  Private
//
//  Created by 최세근 on 2023/09/22.
//

import SwiftUI

struct CatecoryView: View {
    @Binding var categoryAlert: Bool /// 카테고리 초과 알럿
    @Binding var myselectedCategory: [String]

    @State private var selectedCategory: [String] = []
    @State private var selectedCategories: Set<Category> = []
    @State private var showAlert = false
    @State private var selectedToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    private let maxSelectedCategories = 3
    let filteredCategories = Category.filteredCases

    var body: some View {
        HStack {
            Text("카테고리")
                .font(.pretendardMedium18)
                .foregroundStyle(Color.privateColor)
                .padding(.leading, 5)
            Text("(최대 3개)")
                .font(.pretendardRegular12)
                .foregroundColor(.secondary)
        }
        
        LazyVGrid(columns: createGridColumns(), spacing: 20) {
            ForEach (filteredCategories.indices, id: \.self) { index in
                VStack {
                    if selectedToggle[index] {
                        Text(MyCategory.allCases[index].categoryName)
                            .font(.pretendardMedium16)
                            .foregroundColor(.black)
                            .frame(width: 70, height: 30)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 4)
                            .background(Color.privateColor)
                            .cornerRadius(7)
                    } else {
                        Text(MyCategory.allCases[index].categoryName)
                            .font(.pretendardMedium16)
                            .foregroundColor(.primary)
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
                    toggleCategorySelection(at: index)
                    print("선택한 카테고리: \(myselectedCategory), 선택 된 Index토글: \(selectedToggle)")
                }
            }
        }
        .padding(.trailing, 8)
    } // body
    /// 카테고리 선택과 지우기, 선택초과 시 알럿 함수
    func toggleCategorySelection(at index: Int) {
        if categoryAlert {
            return
        }
        selectedToggle[index].toggle()
        let categoryName = MyCategory.allCases[index].categoryName

        if selectedToggle[index] {
            if myselectedCategory.count < maxSelectedCategories {
                myselectedCategory.append(categoryName)
            } else {
                categoryAlert = true
                selectedToggle[index] = false
            }
        } else if let selectedIndex = myselectedCategory.firstIndex(of: categoryName) {
            myselectedCategory.remove(at: selectedIndex)
        }
    }
    /// Grid를 같은 크기로 4줄씩 정렬하기
    func createGridColumns() -> [GridItem] {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
        return columns
    }
}

struct CatecoryView_Previews: PreviewProvider {
    static var previews: some View {
        CatecoryView(categoryAlert: .constant(true), myselectedCategory: .constant([]))
    }
}
