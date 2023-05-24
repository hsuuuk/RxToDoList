//
//  Section.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxDataSources

struct Section {
    var headerTitle: String
    var items: [Task]
}

extension Section: AnimatableSectionModelType {
    var identity: String {
        return headerTitle
    }

    init(original: Section, items: [Task]) {
        self = original
        self.items = items
    }
}
