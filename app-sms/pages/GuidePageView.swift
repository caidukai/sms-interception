//
//  GuidePageView.swift
//  app-sms
//
//  Created by 王海波 on 2021/10/5.
//

import SwiftUI

struct GuidePageView: View {
    let hiddenFirstStart:()->Void
    @State var selection = 1
    func handleNext(idx: Int){
        print("sassaass==")
        selection = idx
    }
    var body: some View {
        VStack {
            
            TabView(selection: $selection) {
                  /// 里面的具体内容，我们写了三页
                VStack{
                    Text("基于Core ML的机器学习").font(.system(size: 28, weight: .bold))
                    Image("start1").frame(width: 350)
                    Button(action: { self.handleNext(idx:2) }) { Text("下一步") }.buttonStyle(SOCActionButton())
                    Button(action: { self.handleNext(idx:2) }) { Text("跳过") }.buttonStyle(SOCEmptyButton())
                }.padding(.horizontal, 20).tag(1)
                VStack{
                    Text("支持自定义关键词手机号").font(.system(size: 28, weight: .bold))
                    Image("start2").frame(width: 350)
                    Button(action: { self.handleNext(idx:3) }) { Text("下一步") }.buttonStyle(SOCActionButton())
                    Button(action: { self.handleNext(idx:3) }) { Text("跳过") }.buttonStyle(SOCEmptyButton())
                }.padding(.horizontal, 20).tag(2)
                VStack{
                    Text("轻松设置开启").font(.system(size: 28, weight: .bold))
                    Image("start3").frame(width: 350)
                    Button(action: {
                        self.hiddenFirstStart()
                    }) {
                        Text("完成")
                    }.buttonStyle(SOCActionButton())
                    Button(action: { self.hiddenFirstStart() }) { Text("跳过") }.buttonStyle(SOCEmptyButton())
                }.padding(.horizontal, 20).tag(3)
                  
            }
            .tabViewStyle(PageTabViewStyle())
            .animation(.spring())
        }.background(Color.white)
    }
}

//struct GuidePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        GuidePageView()
//    }
//}
