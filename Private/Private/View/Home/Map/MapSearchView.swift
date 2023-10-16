//
//  MapSearchView.swift
//  Private
//
//  Created by 최세근 on 10/13/23.
//

import SwiftUI
import NMapsMap

struct MapSearchView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var locationSearchStore = LocationSearchStore.shared
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    @EnvironmentObject var shopStore: ShopStore

    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult
    @Binding var coord: NMGLatLng
    @Binding var selection: Int

    @State private var searchText: String = ""
    @State private var lat: String = ""
    @State private var lng: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            SearchBarTextField(text: $searchText, placeholder: "원하는 위치명을 입력하세요.")
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationSearchStore.searchResultList, id: \.self) { location in
                        Button {
//                            guard let locationManager = coordinator.locationManager else { return }
                            showLocation = false
                            searchResult = location

                            selection = 1
                            
                            lat = formatCoordinates(location.mapy, 2) ?? ""
                            lng = formatCoordinates(location.mapx, 3) ?? ""
                            
                            coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                            
                            print("위도값: \(lat), 경도값: \(lng)")
                            coordinator.moveCameraPosition()
                            dismiss()
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(location.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                    .foregroundStyle(.primary)
                                Text("\(location.roadAddress)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                    }
                }
            }
            .onChange(of: searchText, perform: { _ in
                locationSearchStore.requestSearchLocationResultList(query: searchText)
            })
        }
        .padding()
    }
    func formatCoordinates(_ input: String, _ index: Int) -> String? {
        if input.count < 7 {
            return nil // 최소 7자리 이상의 문자열이어야 합니다.
        }
        
        // 문자열을 index를 사용하여 처리합니다.
        let index = input.index(input.startIndex, offsetBy: index)
        
        // Substring을 사용하여 3번째와 4번째 문자 앞에 점을 추가합니다.
        var output = input
        output.insert(".", at: index)
        
        return output
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView(showLocation: .constant(true), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")), coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), selection: .constant(1))
    }
}
