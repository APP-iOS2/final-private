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
    
    func backButtonArrow() -> some View {
        self.modifier(BackButtonArrowModifier())
    }
    
    
    func backButtonX() -> some View {
        self.modifier(BackButtonXModifier())
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
