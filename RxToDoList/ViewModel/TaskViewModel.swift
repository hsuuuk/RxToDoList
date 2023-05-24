//
//  TaskViewModel.swift
//  RXToDoList
//
//  Created by 심현석 on 2023/05/24.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class TaskViewModel {
    
    var sectionObservable = BehaviorRelay(value: [Section]())
    
    init() {
        let sections = [
            Section(headerTitle: "2023년 5월 24일", items: [
                        Task(title: "점심 약속", description: "혼자서 점심약속", date: Date(), time: "3: 20"),
                        Task(title: "빨래 널기", description: "널어서 말리기", date: Date(), time: "3: 20")
            ]),
            Section(headerTitle: "항상", items: [
                Task(title: "아침 먹기", description: "오트밀 50g", date: Date(), time: "3: 20")
            ])
        ]

        sectionObservable.accept(sections)
    }
}
