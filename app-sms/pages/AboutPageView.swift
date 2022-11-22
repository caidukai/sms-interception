//
//  AboutPageView.swift
//  sms
//
//  Created by Newegg on 2021/8/19.
//

import SwiftUI

struct AboutPageView: View {
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("常见问题").padding(6)){
                    NavigationLink(destination: WebViewPage(request: URLRequest(url: URL(string: "https://sms.dukaiapp.com/about/use")!))){
                        Text("如何使用？")
                    }
                    NavigationLink(destination: WebViewPage(request: URLRequest(url: URL(string: "https://sms.dukaiapp.com/about/remove")!))){
                        Text("如何从垃圾短信中移出？")
                    }
                }
                Section(header: Text("关于").padding(6)){
                    NavigationLink(destination: WebViewPage(request: URLRequest(url: URL(string: "https://sms.dukaiapp.com/about/agreement")!))){
                        Text("隐私协议")
                    }
                    NavigationLink(destination: WebViewPage(request: URLRequest(url: URL(string: "https://sms.dukaiapp.com/about/aboutapp")!))){
                        Text("关于应用")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("更多")
        }
    }
    init() {
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().sectionIndexBackgroundColor = .clear
    }
}

struct AboutPageView_Previews: PreviewProvider {
    static var previews: some View {
        AboutPageView()
    }
}
