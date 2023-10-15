//
//  DefaultConfiguration.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import RealmSwift
import Foundation

/// 하루를 나눌 때 기본적으로 적용될 값들을 가지고 있는 Table
///
/// 오직, 단 하나의 recode를 가지고 있어야한다.
final class DefaultConfiguration: Object {
    /// 취침 시각
    @Persisted var bedTime: Date
    /// 기상 시각
    @Persisted var wakeUpTime: Date
    /// 수면 시간, "분"으로 변환한 값
    @Persisted var sleepHourToMinute: Int
    /// 생활 시간, "분"으로 변환한 값
    @Persisted var lifeHourToMinute: Int
    /// 하루를 나눈 값
    @Persisted var dividedValue: Int

    convenience init(
        bedTime: Date,
        wakeUpTime: Date,
        sleepHourToMinute: Int,
        lifeHourToMinute: Int,
        dividedValue: Int
    ) {
        self.init()
        self.bedTime = bedTime
        self.wakeUpTime = wakeUpTime
        self.sleepHourToMinute = sleepHourToMinute
        self.dividedValue = dividedValue
    }
}
