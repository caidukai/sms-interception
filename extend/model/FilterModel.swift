//
//  File.swift
//  extend
//
//  Created by 王海波 on 2021/8/27.
//

import Foundation
import CoreML

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
class FilterModel {
    let local = UserDefaults(suiteName: "group.com.dukaiapp.app.app-sms")
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var items:[FilterItem] = []
    var keywordType:Bool = true
    var moblieType:Bool = true
    
    func get(msg:String, phone: String) -> String {
        if(keywordType){
            let keyWords:[String] = items.filter{ $0.type == .keyword }.map { (item) -> String in
                return item.t
            }
            let b:Bool = keyWords.contains(where: msg.contains)
            if b {
                return "2"
            }
        }
        
        if(moblieType) {
            let mobiles:[String] = items.filter{ $0.type == .mobile }.map { (item) -> String in
                return item.t
            }
            let c:Bool = mobiles.contains(where: phone.contains)
            if c {
                return "2"
            }
        }

        
        if let m:laji = try? laji(configuration: MLModelConfiguration()){
            guard let output = try? m.prediction(text: msg) else {
                return "1"
            }

            return String(output.label)
        }
        return "1"
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
