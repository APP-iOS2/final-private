//
//  MyPageView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(root: .constant(true), selection: .constant(5))
    }
}