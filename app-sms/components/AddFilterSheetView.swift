//
//  AddFilterSheetView.swift
//  sms
//
//  Created by Newegg on 2021/8/20.
//

import SwiftUI


struct AddFilterSheetView: View {
    @Binding var showSheetView: Bool
    @ObservedObject var filterItems:FilterItemsModel
    
    func handleAdd(){
        if(filterItems.t.isEmpty){
            return
        }
        let item:FilterItem = FilterItem(id: UUID().uuidString, t: filterItems.t, type: .keyword, status: .off)
        filterItems.addItem(item: item)
        filterItems.clearEmpty()
        self.showSheetView = false
    }
    
    var body: some View {
        NavigationView {
            
            VStack{
                TextField("请输入关键词", text: $filterItems.t).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    .frame(width: 280,height: 80)
                
                Button(action: {
                    self.handleAdd()
                }) {
                    HStack{
                        Text("添加规则")
                            .padding(.horizontal)
                    }.padding()

                }
                .foregroundColor(Color.white)
                .background(!filterItems.t.isEmpty ? Color.blue: Color.gray )
                .cornerRadius(8)
                .padding()
                Text("暂时仅支持添加关键词过滤").font(.caption2).foregroundColor(.gray)
            }
            .navigationBarTitle(Text("添加关键词拦截"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showSheetView = false
                }) {
                    Text("取消").bold()
            })
        }
    }
}


//struct AddFilterSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFilterSheetView()
//    }
//}

