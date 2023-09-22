//
//  MainHomeView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct MainHomeView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeView(root: .constant(true), selection: .constant(1))
    }
}
