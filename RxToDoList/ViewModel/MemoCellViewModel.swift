//
//  MemoCellViewModel.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoCellViewModel {
    let titleDriver: Driver<String>
    let contentDriver: Driver<String>
    let dateDriver: Driver<String>
    
    init(memo: Memo) {
        titleDriver = BehaviorRelay(value: memo.title).asDriver()
        contentDriver = BehaviorRelay(value: memo.content).asDriver()
        dateDriver = BehaviorRelay(value: memo.date).asDriver()
    }
}
