//
//  Memo.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit
import RxDataSources

struct Memo {
    var title: String
    var content: String
    var date: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.date = Date().toStringDate()
    }
}

extension Memo: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}

