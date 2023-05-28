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

    var selectedDate = BehaviorRelay(value: Date())
    
    var filteredScheduledTask: Observable<[Task]> {
        return Observable.combineLatest(sectionObservable.asObservable(), selectedDate.asObservable())
            .map { sections, selectedDate in
                return sections[0].items.filter { Calendar.current.isDate($0.date.toDate() ?? Date(), inSameDayAs: selectedDate)}
            }
    }
    
    //var filteredSections = BehaviorRelay<[section]>(value: [])
    var filteredSections: Observable<[Section]> {
        return Observable.combineLatest(sectionObservable.asObservable(), filteredScheduledTask)
            .map { [weak self] sections, scheduledTasks in
                let alwaysTask = sections[1].items
                
                return [
                    Section(headerTitle: self?.selectedDate.value.toDateString() ?? "", items: scheduledTasks),
                    Section(headerTitle: "항상", items: alwaysTask)
                ]
            }
    }
    
    var filteredFirstSection: Observable<[Section]> {
        return filteredSections.map { [$0[0]] }
    }
    
    init() {
//        let sections = [
//            Section(headerTitle: "2023년 5월 24일", items: [
//                Task(title: "점심 약속", description: "혼자서 점심약속", date: "", time: "오전 11:20")
//            ]),
//            Section(headerTitle: "항상", items: [
//                Task(title: "아침 먹기", description: "오트밀 50g", date: "", time: "오후 3:20")
//            ])
//        ]
        
        let sections = [
            Section(headerTitle: Date().toDateString(), items: []),
            Section(headerTitle: "항상", items: [])
        ]
        
        sectionObservable.accept(sections)
    }
    
//    func getFilteredSections() {
//        let alwaysTask = sectionObservable.value[1]
//
//        let scheduledTasks = sections[0].items.filter { item in
//            guard let itemDate = item.date else {
//                return false
//            }
//            return Calendar.current.isDate(itemDate, inSameDayAs: selectedDate.value)
//        }
//
//        let updatedSections = [
//            Section(headerTitle: selectedDate.value, items: scheduledTasks),
//            Section(headerTitle: "항상", items: alwaysTask)
//        ]
//
//        filteredSections.accept(updatedSections)
//    }

//    lazy var scheduledTaskObservable = sectionObservable
//        .map { sections in
//            guard let firstSection = sections.first else { return [String: [Task]]() }
//
//            let tasks = firstSection.items
//            let scheduledTask = Dictionary(grouping: tasks, by: { $0.date })
//            return scheduledTask
//        }
    
    func toggleIsCompleted(indexPath: IndexPath) {
        var sections = sectionObservable.value
        sections[indexPath.section].items[indexPath.row].isCompleted.toggle()
        sectionObservable.accept(sections)
    }
    
    func addTask(newTask: Task, sectionIndex: Int) {
        var sections = sectionObservable.value
        sections[sectionIndex].items.append(newTask)
        sectionObservable.accept(sections)
    }
}
