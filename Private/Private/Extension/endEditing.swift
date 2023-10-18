//
//  endEditing.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import UIKit

extension UIApplication {
    func endEditing() {  // 키보드 사라짐
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
