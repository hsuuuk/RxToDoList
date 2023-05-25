//
//  TaskCellViewModel.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/25.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class TaskCellViewModel {
    let titleDriver: Driver<String>
    let timeDriver: Driver<String>
    let descriptionDriver: Driver<String>
    let isCompletedDriver: Driver<Bool>

    init(task: Task) {
        titleDriver = BehaviorRelay(value: task.title).asDriver()
        timeDriver = BehaviorRelay(value: task.time).asDriver()
        descriptionDriver = BehaviorRelay(value: task.description).asDriver()
        isCompletedDriver = BehaviorRelay(value: task.isCompleted).asDriver()
    }
}
