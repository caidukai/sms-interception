//
//  WebViewPage.swift
//  app-sms
//
//  Created by 王海波 on 2021/9/9.
//

//
//  WebViewPage.swift
//  app-sms
//
//  Created by egg on 2021/9/9.
//

import SwiftUI
import WebKit

struct WebViewPage : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

#if DEBUG
struct WebViewPage_Previews : PreviewProvider {
    static var previews: some View {
        WebViewPage(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
#endif
