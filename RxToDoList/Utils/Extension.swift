//
//  Extension.swift
//  RxToDoList
//
//  Created by 심현석 on 2023/05/25.
//

import UIKit

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.date(from: self)
    }
}

extension Date {
    func toStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: self)
    }
    
    func toStringTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: self)
    }
}
