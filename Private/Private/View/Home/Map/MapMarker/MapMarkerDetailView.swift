//
//  MapMarkerDetailView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//

import SwiftUI

struct MapMarkerDetailView: View {
    
    @Binding var markerTitle: String
    @Binding var isEditing: Bool

    var body: some View {
        VStack {
            TextField("장소를 입력하세요", text: $markerTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct MapMarkerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapMarkerDetailView(markerTitle: .constant(""), isEditing: .constant(true))
    }
}
