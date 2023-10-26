//
//  UseDay.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import Foundation
import RealmSwift

final class UseDay: Object {
    @Persisted(primaryKey: true) var ymd: String
    @Persisted var whenIsBedTime: Int
    @Persisted var whenIsWakeUpTime: Int
    @Persisted var howMuchLifeTime: Int
    @Persisted var dividedValue: Int
    /// 나눠진 하루들
    @Persisted var dividedDayList: List<DividedDay>

//    var toUseDay: UseDay {
//
//
//        UseDay(
//            ymd: ymd,
//            whenIsBedTime: whenIsBedTime,
//            whenIsWakeUpTime: whenIsWakeUpTime,
//            howMuchLifeTime: howMuchLifeTime,
//            dividedValue: dividedValue,
//            dividedDayList: <#T##[DividedDay]#>
//        )
//
//
//    }


    convenience init(
        ymd: String,
        whenIsBedTime: Int,
        whenIsWakeUpTime: Int,
        howMuchLifeTime: Int,
        dividedValue: Int,
        dividedDayList: [DividedDay]
    ) {
        self.init()
        self.ymd = ymd
        self.whenIsBedTime = whenIsBedTime
        self.whenIsWakeUpTime = whenIsWakeUpTime
        self.howMuchLifeTime = howMuchLifeTime
        self.dividedValue = dividedValue
        self.dividedDayList.append(objectsIn: dividedDayList)
    }

    /// 모든 나눠진 하루의 Todo 개수를 알려주는 프로퍼티
    var allDividedDayTodoCount: Int {
        var count = 0
        dividedDayList.forEach {
            count += $0.todoList.count
        }
        return count
    }

}
