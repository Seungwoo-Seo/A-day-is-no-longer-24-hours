//
//  SleepTimeViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import Foundation

final class SleepTimeViewModel {
    /// 취침 시간
    let bedTime: Observable<Date>
    /// 기상 시간
    let wakeUpTime: Observable<Date>
    /// 수면 시간
    let sleepTime: Observable<Date>
    /// 수면 시간 유효성
    let sleepTimeValidity: Observable<Bool> // Bool에서 enum으로 변경 가능성 있음 => ex 좋다 4~8시간, 작다 1>, 크다 20<, 좀 많다 9<

    init() {
        let startPointValue = TimeInterval(1 * 60 * 60)
        let endPointValue = TimeInterval(7 * 60 * 60)
        let duration = endPointValue - startPointValue

        let bedTime = Date(timeIntervalSinceReferenceDate: startPointValue)
        let wakeUpTime = Date(timeIntervalSinceReferenceDate: endPointValue)
        let sleepTime = Date(timeIntervalSinceReferenceDate: duration)

        self.bedTime = Observable(bedTime)
        self.wakeUpTime = Observable(wakeUpTime)
        self.sleepTime = Observable(sleepTime)
        // 처음에 유효한 시간을 설정해서 보내니까 true
        self.sleepTimeValidity = Observable(true)
    }
    
}

extension SleepTimeViewModel {

    // 라이브러리에 예시보고 적용한거라 다시 공부 필요
    // 5분 단위로만 설정 가능하게 해주는 메소드
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }

    // 위치를 시간으로 변환해서 값 변경해주는 메소드
    func updateTimes(
        startPointValue: CGFloat,
        endPointValue: CGFloat
    ) {
        let bedTimePoint = TimeInterval(startPointValue)
        let wakeUpTimePoint = TimeInterval(endPointValue)
        let sleepTimePoint = wakeUpTimePoint - bedTimePoint
        let sleepTimeDate = Date(timeIntervalSinceReferenceDate: sleepTimePoint)

        bedTime.value = Date(
            timeIntervalSinceReferenceDate: bedTimePoint
        )
        wakeUpTime.value = Date(
            timeIntervalSinceReferenceDate: wakeUpTimePoint
        )
        self.sleepTime.value = sleepTimeDate

        // MARK: - 성공: 음수 양수 생각할 필요없이 시와 분을 뽑아서 전부 분으로 바꿔서 1200(=8시간)분, 60(=1시간)분으로 조건문 처리
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: sleepTimeDate)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let sleepTimeToMinute = hour * 60 + minute

        if sleepTimeToMinute > 1200 {
            sleepTimeValidity.value = false
        } else if sleepTimeToMinute < 60 {
            sleepTimeValidity.value = false
        } else {
            sleepTimeValidity.value = true
        }

        // MARK: - 실패: point로 연산하면 양수는 처리가 잘되지만 음수가 나올 때 어떻게 로직을 짜야하는지 머리가 안돌아가네
//        //양수일 때
//        if sleepTimePoint > (20 * 60 * 60) {
//            sleepTimeValidity.value = false
//        } else if sleepTimePoint >= 0 && sleepTimePoint < (1 * 60 * 60) {
//            sleepTimeValidity.value = false
//        //음수일 때
//        } else if abs(sleepTimePoint) > (1 * 60 * 60) {
//            sleepTimeValidity.value = false
//        } else if abs(sleepTimePoint) < (20 * 60 * 60) {
//            sleepTimeValidity.value = false
//        } else {
//            sleepTimeValidity.value = true
//        }
    }

}
