//
//  DefaultTimeConfigViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import Foundation

final class DefaultTimeConfigViewModel {
    // MARK: - bind from DefaultDayConfigurationViewController
    let whenIsBedTimeToString = Observable("오전 01:00")
    let whenIsWakeUpTimeToString = Observable("오전 07:00")
    /// 수면 시간을 특정 문자열로 변환한 값
    let howMuchSleepTimeToString = Observable("6 시간")
    /// 수면 시간 유효성
    // 처음에 유효한 시간을 설정해서 보내니까 true
    // Bool에서 enum으로 변경 가능성 있음 => ex 좋다 4~8시간, 작다 1>, 크다 20<, 좀 많다 9<
    let howMuchSleepTimeValidity = Observable(true)

    // MARK: - bind from OnboardingViewModel
    /// 취침 시각, "분"으로 표현한 값
    let whenIsBedTime = Observable(60) // 01:00시
    /// 기상 시각, "분"으로 표현한 값
    let whenIsWakeUpTime = Observable(420) // 07:00시
    /// 수면 시간, "분"으로 변환한 값
    let howMuchSleepTime = Observable(360) // 6시간
    /// 생활 시간, "분"으로 변환한 값
    let howMuchLivingTime = Observable(1080) // 18시간

    // MARK: - Event, bind from OnboardingTabViewController
    /// "다음으로" 버튼 탭 이벤트
    let nextButtonTapped = Observable(false)

}

// MARK: - RangeCircularSlider
extension DefaultTimeConfigViewModel {

    // TODO: 1
//    func valueChangedRangeCircularSlider(
//        adStartPointValue: inout CGFloat,
//        adEndPointValue: inout CGFloat,
//        startPointValue: CGFloat,
//        endPointValue: CGFloat
//    ) {
//        let minutes = adStartPointValue / 60
//        let adjustedMinutes =  ceil(minutes / 5.0) * 5
//        adStartPointValue = adjustedMinutes * 60
//
//        let minutes1 = adEndPointValue / 60
//        let adjustedMinutes1 =  ceil(minutes1 / 5.0) * 5
//        adEndPointValue = adjustedMinutes1 * 60
//
//        updateTimes(
//            startPointValue: startPointValue,
//            endPointValue: endPointValue
//        )
//    }

}

// MARK: - 비즈니스
extension DefaultTimeConfigViewModel {

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
        // whenIsBedTime
        let bedTimePointValue = TimeInterval(startPointValue)
        let bedTimeToDate = Date(timeIntervalSinceReferenceDate: bedTimePointValue)
        whenIsBedTimeToString.value = dateFormatter.string(from: bedTimeToDate)
        whenIsBedTime.value = toMinute(bedTimeToDate)

        // whenIsWakeUpTime
        let wakeUpTimePointValue = TimeInterval(endPointValue)
        let wakeUpTimeToDate = Date(timeIntervalSinceReferenceDate: wakeUpTimePointValue)
        whenIsWakeUpTimeToString.value = dateFormatter.string(from: wakeUpTimeToDate)
        whenIsWakeUpTime.value = toMinute(wakeUpTimeToDate)

        // howMuchSleepTime
        let sleepTimePointValue = wakeUpTimePointValue - bedTimePointValue
        let sleepTimeDate = Date(timeIntervalSinceReferenceDate: sleepTimePointValue)
        let howMuchSleepTime = toMinute(sleepTimeDate)
        howMuchSleepTimeToString.value = minuteToString(minuteValue: howMuchSleepTime)
        self.howMuchSleepTime.value = howMuchSleepTime

        // howMuchLivingTime
        let dayToMinute = 24 * 60
        let howMuchLivingTime = dayToMinute - howMuchSleepTime
        self.howMuchLivingTime.value = howMuchLivingTime
    }

    /// 수면 시간을 계산하고 분으로 바꾼 뒤 해당 값이 1200(=20시간, 최대 수면)분 보다 크거나 60(=1시간, 최소 수면)분보다 작은지 검사
    func updateHowMuchSleepTimeValidity() {
        if howMuchSleepTime.value > 1200 {
            howMuchSleepTimeValidity.value = false
        } else if howMuchSleepTime.value < 60 {
            howMuchSleepTimeValidity.value = false
        } else {
            howMuchSleepTimeValidity.value = true
        }
    }

}

private extension DefaultTimeConfigViewModel {

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a HH:mm"
        return dateFormatter
    }

    /// 분으로 바꿔주는 메서드
    func toMinute(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        return hour * 60 + minute
    }

    /// "분"을 적절한 문자열로 변환 해주는 메소드
    func minuteToString(minuteValue: Int) -> String {
        let hour = minuteValue / 60
        let minute = minuteValue % 60

        if hour == 0 {
            return "\(minute) 분"
        }

        if minute == 0 {
            return "\(hour) 시간"
        } else {
            return "\(hour) 시간 \(minute) 분"
        }
    }

}
