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

class TaskViewModel {
    
    var sectionObservable = BehaviorRelay(value: [Section]())
    
    init() {
        let sections = [
            Section(headerTitle: "2023년 5월 24일", items: [
                Task(title: "점심 약속", description: "혼자서 점심약속", date: "", time: "3: 20")
            ]),
            Section(headerTitle: "항상", items: [
                Task(title: "아침 먹기", description: "오트밀 50g", date: "", time: "3: 20")
            ])
        ]

        sectionObservable.accept(sections)
    }
    
    func toggleIsCompleted(indexPath: IndexPath) {
        var sections = sectionObservable.value
        sections[indexPath.section].items[indexPath.row].isCompleted.toggle()
        sectionObservable.accept(sections)
    }
    
    func addTask(newTask: Task, index: Int) {
        var sections = sectionObservable.value
        sections[index].items.append(newTask)
        sectionObservable.accept(sections)
    }
}
