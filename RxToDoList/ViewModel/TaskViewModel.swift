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
    
    var filteredSection: Observable<[Section]> {
        return Observable.combineLatest(sectionObservable.asObservable(), selectedDate.asObservable())
            .map { sections, selectedDate in
                
                if let index = sections.firstIndex(where: { $0.headerTitle == selectedDate.toStringDate()}) {
                    return [sections[index]]
                }
                
                return [Section(headerTitle: selectedDate.toStringDate(), items: [])]
            }
    }
    
    var searchFilteredSection = BehaviorRelay(value: [Section]())
    
    init() {
        let sections = [
            Section(headerTitle: "할일", items: [])
        ]
        
        sectionObservable.accept(sections)
    }
    
    func toggleIsCompleted(indexPath: IndexPath) {
        var sections = sectionObservable.value
        sections[indexPath.section].items[indexPath.row].isCompleted.toggle()
        sectionObservable.accept(sections)
    }
    
    func toggleIsCompleted(indexPath: IndexPath, date: Date) {
        var sections = sectionObservable.value
        guard let index = sections.firstIndex(where: { $0.headerTitle == date.toStringDate() }) else { return }
        sections[index].items[indexPath.row].isCompleted.toggle()
        sectionObservable.accept(sections)
    }
    
    func addTask(newTask: Task) {
        var sections = sectionObservable.value
        
        if newTask.date == "" {
            sections[0].items.append(newTask)
            sectionObservable.accept(sections)
        } else {
            if sections.filter({ $0.headerTitle == newTask.date }).isEmpty {
                let newSection = Section(headerTitle: newTask.date, items: [newTask])
                sections.append(newSection)
                sectionObservable.accept(sections)
            } else {
                if let index = sections.firstIndex(where: { $0.headerTitle == newTask.date }) {
                    sections[index].items.append(newTask)
                    sectionObservable.accept(sections)
                }
            }
        }
    }
    
    func updateTask(updateTask: Task, indexPath: IndexPath) {
        deleteTask(indexPath: indexPath)
        addTask(newTask: updateTask)
    }
    
    func deleteTask(indexPath: IndexPath) {
        var sections = sectionObservable.value
        sections[indexPath.section].items.remove(at: indexPath.row)
        if sections[indexPath.section].items.isEmpty {
            sections.remove(at: indexPath.section)
        }
        sectionObservable.accept(sections)
    }
}
