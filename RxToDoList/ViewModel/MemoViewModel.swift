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
    
    func addMemo(newMemo: Memo) {
        var memos = memoObservable.value
        memos.append(newMemo)
        memoObservable.accept(memos)
    }
    
    func updateMemo(updateMemo: Memo, index: Int) {
        var memos = memoObservable.value
        memos[index] = updateMemo
        memoObservable.accept(memos)
    }
    
    func deleteMemo(index: Int) {
        var memos = memoObservable.value
        memos.remove(at: index)
        memoObservable.accept(memos)
    }
}
