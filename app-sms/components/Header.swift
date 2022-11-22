//
//  Header.swift
//  app-sms
//
//  Created by 王海波 on 2021/10/4.
//

import SwiftUI

struct Header: View {
    @Binding var showSheetView:Bool
    var body: some View {
        HStack{
            HStack{
                Text("关键词")
                Spacer()
                Button(action: {
                    self.showSheetView.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(Font.system(.title))
                }
            }
        }
    }
}
