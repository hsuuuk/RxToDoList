//
//  SearchCellViewModel.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/30.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SearchCellViewModel {
    let titleDriver: Driver<String>
    let descriptionDriver: Driver<String>
    
    init(task: Task) {
        titleDriver = BehaviorRelay(value: task.title).asDriver()
        descriptionDriver = BehaviorRelay(value: task.description).asDriver()
    }
}
