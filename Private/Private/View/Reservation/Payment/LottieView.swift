//
//  CompleteLottieView.swift
//  Private
//
//  Created by 박성훈 on 10/21/23.
//

import Foundation
import SwiftUI
import Lottie
import UIKit

// 로티 애니메이션 뷰
struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var name : String
    var loopMode: LottieLoopMode
    
    init(fileName: String = "", loopMode : LottieLoopMode = .loop){
        self.name = fileName
        self.loopMode = loopMode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {
    }
}
