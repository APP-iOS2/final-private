//
//  MapSearchView.swift
//  Private
//
//  Created by 최세근 on 10/13/23.
//

import SwiftUI
import NMapsMap

struct MapSearchView: View {
    
    @ObservedObject private var locationSearchStore = LocationSearchStore.shared
    @ObservedObject var coordinator: Coordinator = Coordinator.shared

    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult
    @Binding var coord: NMGLatLng
    @Binding var selection: Int

    @State private var searchText: String = ""
    
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchBarTextField(text: $searchText, placeholder: "원하는 위치명을 입력하세요.")
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationSearchStore.searchResultList, id: \.self) { location in
                        Button {
                            guard let locationManager = coordinator.locationManager else { return }
                            showLocation = false
                            searchResult = location
                            print(location.mapx)
                            selection = 1
                            coordinator.coord = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0.0, lng: locationManager.location?.coordinate.longitude ?? 0.0)
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

}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView(showLocation: .constant(true), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")), coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), selection: .constant(1))
    }
}
