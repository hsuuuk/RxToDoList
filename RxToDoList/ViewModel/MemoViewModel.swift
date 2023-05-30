//
//  MemoViewModel.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/29.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoViewModel {
    
    var memoObservable = BehaviorRelay(value: [Memo]())
    
    init() {
        let memos = [
        Memo(title: "안녕하세요", content: "지금부터 메모"),
        Memo(title: "감사합니다", content: "지금부터 메모")
        ]
        
        memoObservable.accept(memos)
    }
    
    func addMemo(newMemo: Memo) {
        var memos = memoObservable.value
        memos.append(newMemo)
        memoObservable.accept(memos)
    }
}
