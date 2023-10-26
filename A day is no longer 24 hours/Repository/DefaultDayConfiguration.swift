//
//  DefaultDayConfiguration.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import Foundation
import RealmSwift

/// 하루를 나눌 때 기본적으로 적용될 값들을 가지고 있는 Table
///
/// 오직, 단 하나의 recode를 가지고 있어야한다.
final class DefaultDayConfiguration: Object {
    /// 취침 시각, 해당 시각을 "분"으로 표현힌 값
    @Persisted var whenIsBedTime: Int
    /// 기상 시각, 해당 시각을 "분"으로 표현힌 값
    @Persisted var whenIsWakeUpTime: Int
    /// 수면 시간, "분"으로 변환한 값
    @Persisted var howMuchSleepTime: Int
    /// 생활 시간, "분"으로 변환한 값
    @Persisted var howMuchLivingTime: Int
    /// 하루를 나눈 값
    @Persisted var dividedValue: Int
    /// 나눠진 하루들
    @Persisted var dividedDayList = List<DividedDay>()

    convenience init(
        whenIsBedTime: Int,
        whenIsWakeUpTime: Int,
        howMuchSleepTime: Int,
        howMuchLivingTime: Int,
        dividedValue: Int
    ) {
        self.init()
        self.whenIsBedTime = whenIsBedTime
        self.whenIsWakeUpTime = whenIsWakeUpTime
        self.howMuchSleepTime = howMuchSleepTime
        self.howMuchLivingTime = howMuchLivingTime
        self.dividedValue = dividedValue
    }

}
