//
//  SMSFilterModal.swift
//  sms
//
//  Created by Newegg on 2021/8/23.
//

import SwiftUI

enum FilterItemType : Int, Codable {
    case keyword = 0
    case mobile = 1
}

enum FilterItemStatus: Int, Codable {
    case on = 0
    case off = 1
}

struct FilterItem:Identifiable,Codable {
    let id: String
    let t: String
    let type: FilterItemType
    let status: FilterItemStatus
}

class FilterItemsModel: ObservableObject {
    let local = UserDefaults(suiteName: "group.com.dukaiapp.app.app-sms")
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    @Published var firstStart:Bool = false
    @Published var t:String = ""
    @Published var machineLearningType:Bool = true
    @Published var keywordType:Bool = true
    @Published var moblieType:Bool = true
    @Published var items:[FilterItem] = []
    
    func addItem ( item: FilterItem ) {
        items += [item]
        self.saveLocal(items:items)
    }
    func saveLocal (items:[FilterItem]){
        let data = try! encoder.encode(items)
        let encodedString = String(data: data, encoding: .utf8)!
        local?.set(encodedString, forKey: "fts")
    }
    func clearEmpty () {
        t = ""
    }
    func remove(at o:IndexSet) {
        items.remove(atOffsets:o)
        self.saveLocal(items: self.items)
    }
    
    func setTypeOpenClose(key: String, value: Bool){
        local?.set(value, forKey: key)
    }
    

    init() {
        let keywordBools = local?.bool(forKey: "keywordType")
        if let keywordBools = keywordBools {
            keywordType = keywordBools
        }
        
        let mobileBools = local?.bool(forKey: "moblieType")
        if let mobileBools = mobileBools {
            moblieType = mobileBools
        }
    
        let j = local?.string(forKey: "fts")
        let jsonData = j?.data(using: .utf8)
        if jsonData == nil {
            return
        }
        let result = try! decoder.decode([FilterItem].self, from: jsonData!)
        items = result
    }
}

