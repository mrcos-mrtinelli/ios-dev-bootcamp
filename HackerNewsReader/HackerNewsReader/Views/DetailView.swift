//
//  DetailView.swift
//  HackerNewsReader
//
//  Created by Marcos Martinelli on 3/9/21.
//

import SwiftUI
import WebKit

struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.apple.com")
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let urlString: String?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let safeString = urlString {
            guard let url = URL(string: safeString) else { return }
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
