//
//  Model.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxDataSources

struct Task {
    var title: String
    var description: String
    var date: String
    var time: String
    
    var isCompleted: Bool
    
    init(title: String, description: String, date: String, time: String) {
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.isCompleted = false
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.date = ""
        self.time = ""
        self.isCompleted = false
    }
}

extension Task: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}
