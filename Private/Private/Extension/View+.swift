//
//  View+.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

public let naver_client_ID: String = Bundle.main.naver_client_ID
public let naver_client_Secret: String = Bundle.main.naver_client_Secret

public let naver_map_client_ID: String = Bundle.main.naverMap_client_ID
public let naver_map_client_Secret: String = Bundle.main.naverMap_client_Secret

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
