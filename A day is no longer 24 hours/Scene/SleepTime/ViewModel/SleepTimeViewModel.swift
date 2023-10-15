//
//  SleepTimeViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import Foundation

final class SleepTimeViewModel {
    /// 취침 시각
    let bedTime: Observable<Date>
    /// 기상 시각
    let wakeUpTime: Observable<Date>
    /// 수면 시간, "분"으로 변환한 값
    let sleepHourToMinute: Observable<Int>
    /// 생활 시간, "분"으로 변환한 값
    let lifeHourToMinute: Observable<Int>

    // MARK: - Event
    /// "다음으로" 버튼 탭 이벤트
    let nextButtonTapped: Observable<Bool>

    // MARK: - Just Scene
    /// 수면 시간 유효성
    // 처음에 유효한 시간을 설정해서 보내니까 true
    // Bool에서 enum으로 변경 가능성 있음 => ex 좋다 4~8시간, 작다 1>, 크다 20<, 좀 많다 9<
    let sleepHourToMinuteValidity: Observable<Bool>
    /// 수면 시간을 분으로 바꾼 값을 포멧한 문자열
    let sleepHourToMinuteFormatString: Observable<String?>

    // MARK: - Init
    private init(
        nextButtonTapped: Observable<Bool>,
        sleepHourToMinuteValidity: Observable<Bool>,
        sleepHourToMinuteFormatString: Observable<String?>
    ) {
        self.nextButtonTapped = nextButtonTapped
        self.sleepHourToMinuteValidity = sleepHourToMinuteValidity
        self.sleepHourToMinuteFormatString =         sleepHourToMinuteFormatString

        let bedTimePointValue = TimeInterval(1 * 60 * 60)
        let wakeUpTimePointValue = TimeInterval(7 * 60 * 60)
        let sleepTimePointValue = wakeUpTimePointValue - bedTimePointValue

        let bedTime = Date(timeIntervalSinceReferenceDate: bedTimePointValue)
        let wakeUpTime = Date(timeIntervalSinceReferenceDate: wakeUpTimePointValue)
        let sleepTime = Date(timeIntervalSinceReferenceDate: sleepTimePointValue)

        self.bedTime = Observable(bedTime)
        self.wakeUpTime = Observable(wakeUpTime)

        // 전달 받은 수면시각(Date) -> 수면시간으로 바꾸고
        // 시간을 -> 분으로 바꾼다
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: sleepTime)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let sleepHourToMinute = hour * 60 + minute
        self.sleepHourToMinute = Observable(sleepHourToMinute)

        // 하루를 분으로 바꿔서
        let dayToMinute = 24 * 60
        let lifeHourToMinute = dayToMinute - sleepHourToMinute
        self.lifeHourToMinute = Observable(lifeHourToMinute)
    }

    convenience init() {
        self.init(
            nextButtonTapped: Observable(false),
            sleepHourToMinuteValidity: Observable(true),
            sleepHourToMinuteFormatString: Observable(nil)
        )

        sleepHourToMinute.bind { [weak self] (sleepHourToMinute) in
            guard let self else {return}
            self.sleepHourToMinuteFormatString.value = self.minuteFormat(minuteValue: sleepHourToMinute)
        }
    }

}

// MARK: - RangeCircularSlider
extension SleepTimeViewModel {

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
        let bedTimePointValue = TimeInterval(startPointValue)
        let wakeUpTimePointValue = TimeInterval(endPointValue)
        bedTime.value = Date(timeIntervalSinceReferenceDate: bedTimePointValue)
        wakeUpTime.value = Date(timeIntervalSinceReferenceDate: wakeUpTimePointValue)

        // MARK: - 성공: 음수 양수 생각할 필요없이 시와 분을 뽑아서 전부 분으로 바꿔서 1200(=20시간)분, 60(=1시간)분으로 조건문 처리
        let sleepTimePointValue = wakeUpTimePointValue - bedTimePointValue
        let sleepTime = Date(timeIntervalSinceReferenceDate: sleepTimePointValue)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: sleepTime)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let sleepHourToMinute = hour * 60 + minute
        self.sleepHourToMinute.value = sleepHourToMinute

        let dayToMinute = 24 * 60
        let lifeHourToMinute = dayToMinute - sleepHourToMinute
        self.lifeHourToMinute.value = lifeHourToMinute

        if sleepHourToMinute > 1200 {
            sleepHourToMinuteValidity.value = false
        } else if sleepHourToMinute < 60 {
            sleepHourToMinuteValidity.value = false
        } else {
            sleepHourToMinuteValidity.value = true
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

    /// "분"을 문자열로 포멧해주는 메소드
    func minuteFormat(minuteValue: Int) -> String {
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
