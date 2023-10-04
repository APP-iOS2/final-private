//
//  ReviewSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct MapReviewSheetView: View {
    
    var feeds: [Feed] = dummyFeeds

    init() {
        // NavigationBar의 배경과 경계선을 투명하게 만들기
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            List(feeds, id: \.id) { feed in
                MapReviewRowView(feed: feed)
            }
            .navigationTitle("팔로워의 리뷰")
            .listStyle(.plain)
            .padding(.top, -15)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barStyle = .black
                nc.navigationBar.isTranslucent = false
                nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            })
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ReviewSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapReviewSheetView()
            .previewDevice("iPhone 14")
    }
}
