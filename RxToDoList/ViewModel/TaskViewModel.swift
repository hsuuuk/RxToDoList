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
    
    var filteredSections: Observable<[Section]> {
        return Observable.combineLatest(sectionObservable.asObservable(), filteredScheduledTask)
            .map { [weak self] sections, scheduledTasks in
                let alwaysTask = sections[1].items
                
                return [
                    Section(headerTitle: self?.selectedDate.value.toDateString() ?? "", items: scheduledTasks),
                    Section(headerTitle: "종일", items: alwaysTask)
                ]
            }
    }
    
    var filteredFirstSection: Observable<[Section]> {
        return filteredSections.map { [$0[0]] }
    }
    
    init() {
        let sections = [
            Section(headerTitle: Date().toDateString(), items: []),
            Section(headerTitle: "종일", items: [])
        ]
        
        sectionObservable.accept(sections)
    }
    
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
