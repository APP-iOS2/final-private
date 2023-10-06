//
//  CatecoryView.swift
//  Private
//
//  Created by 최세근 on 2023/09/22.
//

import SwiftUI

struct CatecoryView: View {
    
    @Binding var selectedCategory: [String]
    @State private var categoryAlert: Bool = false

    @State private var selectedCategories: Set<Category> = []
    @State private var myselectedCategory: [MyCategory] = []
    @State private var selectedToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    private let maxSelectedCategories = 3
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("카테고리")
                    .font(.title2).fontWeight(.semibold)
                Text("(최대 3개)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: createGridColumns(), spacing: 20) {
                ForEach (Category.allCases.indices, id: \.self) { index in
                    VStack {
                        if selectedToggle[index] {
                            Text(Category.allCases[index].categoryName)
                                .font(.body)
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
                        if myselectedCategory.count < maxSelectedCategories || selectedToggle[index] {
                            toggleCategorySelection(at: index)
                            print(myselectedCategory)
                        } else {
                            categoryAlert.toggle()
                            print("3개 초과 선택")
                        }
                    }
                    .alert(isPresented: $categoryAlert) {
                        Alert(
                            title: Text("선택 초과"),
                            message: Text("최대 3개까지 선택 가능합니다."),
                            dismissButton: .default(Text("확인"))
                        )
                    }
                }
            }
        }
    } // body
    func toggleCategorySelection(at index: Int) {
        selectedToggle[index].toggle()
        
        if selectedToggle[index] {
            // If the category is selected, add it to myselectedCategory
            myselectedCategory.append(MyCategory.allCases[index])
        } else {
            // If the category is deselected, remove it from myselectedCategory
            if let selectedIndex = myselectedCategory.firstIndex(of: MyCategory.allCases[index]) {
                myselectedCategory.remove(at: selectedIndex)
            }
        }
        
        // Ensure that myselectedCategory doesn't exceed the maximum allowed categories
        if myselectedCategory.count > maxSelectedCategories {
            myselectedCategory.removeFirst() // Remove the oldest selected category if it exceeds the limit
        }
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
