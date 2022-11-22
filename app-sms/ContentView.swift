//
//  ContentView.swift
//  sms
//
//  Created by Newegg on 2021/8/19.
//

import SwiftUI

struct ContentView: View {
    let local = UserDefaults(suiteName: "group.com.dukaiapp.app.app-sms")
    @StateObject var filterItems = FilterItemsModel()
    @State var hidden = false
    
    func hiddenFirstStart (){
        local?.set(true, forKey: "firstStart")
        hidden = true
    }
    var body: some View {
        ZStack{
            TabView{
                FrontPageView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("首页")
                    }
                
                AboutPageView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("更多")
                    }
            }
            if !hidden {
                GuidePageView(hiddenFirstStart: hiddenFirstStart)
            }
        }
    }
    init() {
        let firstStartBools = local?.bool(forKey: "firstStart")
        if let firstStartBools = firstStartBools {
            if(firstStartBools == false) {
                local?.set(true, forKey: "keywordType")
                local?.set(true, forKey: "moblieType")
            }
            _hidden = State(initialValue: firstStartBools)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

