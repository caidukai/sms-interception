//
//  FrontPageView.swift
//  sms
//
//  Created by Newegg on 2021/8/19.
//

import SwiftUI

struct TypeFilterHeader: View {
    @Binding var typeFilterIdx: Int
    var body: some View {
        VStack{
            HStack{
                Text("过滤项添加")
                Spacer()
            }
            
            Picker("过滤类型", selection: $typeFilterIdx) {
                Text("关键词").tag(1)
                Text("手机号").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        
    }
}


struct FrontPageView: View {
    let title = "过滤器"
    @State var showSheetView = false
    @State var typeFilterIdx = 1
    @StateObject var filterItems = FilterItemsModel()

    func removeRows(at offsets: IndexSet) {
        filterItems.remove(at: offsets)
    }
    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    Section(header: Text("过滤项开关")){
                        Toggle("关键词过滤", isOn: $filterItems.keywordType).onTapGesture {
                            filterItems.setTypeOpenClose(key: "keywordType", value: !filterItems.keywordType)
                        }
                        Toggle("手机号过滤", isOn: $filterItems.moblieType).onTapGesture {
                            filterItems.setTypeOpenClose(key: "moblieType", value: !filterItems.moblieType)
                        }
                    }
                    
                    Section(header: TypeFilterHeader(typeFilterIdx: $typeFilterIdx)){
                        if typeFilterIdx == 1 {
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.showSheetView.toggle()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(Font.system(.title))
                                }
                            }
                            ForEach(filterItems.items) { item in
                                if item.type == .keyword{
                                    Text(item.t)
                                }
                                
                            }.onDelete(perform: removeRows)
                            if filterItems.items.isEmpty{
                                HStack(){
                                    Spacer()
                                    Text("暂无过滤关键词，请点击右上角+添加").font(.caption2).foregroundColor(.gray)
                                    Spacer()
                                }
        
                            }
                        }
                        
                        if typeFilterIdx == 2 {
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.showSheetView.toggle()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(Font.system(.title))
                                }
                            }
                            ForEach(filterItems.items) { item in
                                if item.type == .mobile{
                                    Text(item.t)
                                }
                                
                            }.onDelete(perform: removeRows)
                            if filterItems.items.isEmpty{
                                HStack(){
                                    Spacer()
                                    Text("暂无过滤手机号，请点击右上角+添加").font(.caption2).foregroundColor(.gray)
                                    Spacer()
                                }
        
                            }
                        }
                        
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(title)
            
        }.sheet(isPresented: $showSheetView) {
            if typeFilterIdx == 1 {
                AddFilterSheetView(showSheetView: self.$showSheetView, filterItems: filterItems)
            }
            
            if typeFilterIdx == 2 {
                AddMoblieFilterSheetView(showSheetView: self.$showSheetView, filterItems: filterItems)
            }
            
        }
    }
    init() {
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().sectionIndexBackgroundColor = .clear
    }
}


extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

struct FrontPageView_Previews: PreviewProvider {
    static var previews: some View {
        FrontPageView()
    }
}
