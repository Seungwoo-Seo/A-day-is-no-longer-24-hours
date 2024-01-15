//
//  DefaultTimeConfigViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/11/27.
//

import Foundation
import RxCocoa
import RxSwift

final class DefaultTimeConfigViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    /// 취침 시각, "분"으로 표현한 값
    let whenIsBedTime = BehaviorRelay(value: 60) // 01:00시
    /// 기상 시각, "분"으로 표현한 값
    let whenIsWakeUpTime = BehaviorRelay(value: 420) // 07:00시
    /// 수면 시간, "분"으로 변환한 값
    let howMuchSleepTime = BehaviorRelay(value: 360) // 6시간
    /// 생활 시간, "분"으로 변환한 값
    let howMuchLivingTime = BehaviorRelay(value: 1080) // 18시간

    let scrollToNext = PublishRelay<Void>()

    struct Input {
        let sliderValueChanged: ControlEvent<Void>
        let pointValueChanged: PublishRelay<(start: CGFloat, end: CGFloat)>
        let nextButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let adjustValue: PublishRelay<Void>
        let whenIsBedTimeToString: BehaviorRelay<String>
        let whenIsWakeUpTimeToString: BehaviorRelay<String>
        let howMuchSleepTimeToString: Observable<String>
        let howMuchSleepTimeState: BehaviorRelay<HowMuchSleepTimeState>
    }

    func transform(input: Input) -> Output {
        let adjustValue = PublishRelay<Void>()
        let whenIsBedTimeToString = BehaviorRelay(value: "오전 01:00")
        let whenIsWakeUpTimeToString = BehaviorRelay(value: "오전 07:00")
        let howMuchSleepTimeToString = howMuchSleepTime
            .withUnretained(self)
            .map { (owner, sleepTimeToMinute) in
                owner.minuteToString(minuteValue: sleepTimeToMinute)
            }
        let howMuchSleepTimeState = BehaviorRelay<HowMuchSleepTimeState>(value: .available)

        input.sliderValueChanged
            .bind(with: self) { owner, void in
                adjustValue.accept(void)
            }
            .disposed(by: disposeBag)

        let timeInterval = input.pointValueChanged
            .map { (pointValue) -> (whenIsBedTimeInterval: TimeInterval, whenIsWakeUpTimeInterval: TimeInterval, howMuchSleepTimeInterval: TimeInterval) in
                let whenIsBedTimeInterval = TimeInterval(pointValue.start)
                let whenIsWakeUpTimeInterval = TimeInterval(pointValue.end)
                let howMuchSleepTimeInterval = whenIsWakeUpTimeInterval - whenIsBedTimeInterval

                return (
                    whenIsBedTimeInterval,
                    whenIsWakeUpTimeInterval,
                    howMuchSleepTimeInterval
                )
            }
            .map { (timeInterval) -> (whenIsBedTimeToDate: Date, whenIsWakeUpTimeToDate: Date, howMuchSleepTimeDate: Date) in
                let whenIsBedTimeToDate = Date(
                    timeIntervalSinceReferenceDate: timeInterval.whenIsBedTimeInterval
                )
                let whenIsWakeUpTimeToDate = Date(
                    timeIntervalSinceReferenceDate: timeInterval.whenIsWakeUpTimeInterval
                )
                let howMuchSleepTimeDate = Date(
                    timeIntervalSinceReferenceDate: timeInterval.howMuchSleepTimeInterval
                )

                return (
                    whenIsBedTimeToDate,
                    whenIsWakeUpTimeToDate,
                    howMuchSleepTimeDate
                )
            }
            .share()

        timeInterval
            .bind(with: self) { owner, date in
                whenIsBedTimeToString.accept(owner.dateFormatter.string(from: date.whenIsBedTimeToDate))
                whenIsWakeUpTimeToString.accept(owner.dateFormatter.string(from: date.whenIsWakeUpTimeToDate))
            }
            .disposed(by: disposeBag)

        timeInterval
            .withUnretained(self)
            .map { (owner, date) -> (whenIsBedTime: Int, whenIsWakeUpTime: Int, howMuchSleepTime: Int, howMuchLivingTime: Int) in
                let whenIsBedTime = owner.toMinute(date.whenIsBedTimeToDate)
                let whenIsWakeUpTime = owner.toMinute(date.whenIsWakeUpTimeToDate)
                let howMuchSleepTime = owner.toMinute(date.howMuchSleepTimeDate)

                let dayToMinute = 24 * 60
                let howMuchLivingTime = dayToMinute - howMuchSleepTime

                return (
                    whenIsBedTime,
                    whenIsWakeUpTime,
                    howMuchSleepTime,
                    howMuchLivingTime
                )
            }
            .bind(with: self) { owner, time in
                owner.whenIsBedTime.accept(time.whenIsBedTime)
                owner.whenIsWakeUpTime.accept(time.whenIsWakeUpTime)
                owner.howMuchSleepTime.accept(time.howMuchSleepTime)
                owner.howMuchLivingTime.accept(time.howMuchLivingTime)
            }
            .disposed(by: disposeBag)

        // 수면 시간을 계산하고 분으로 바꾼 뒤 해당 값이 1200(=20시간, 최대 수면)분 보다 크거나 60(=1시간, 최소 수면)분보다 작은지 검사
        howMuchSleepTime
            .bind(with: self) { owner, sleepTimeToMinute in
                if sleepTimeToMinute > 1200 {
                    howMuchSleepTimeState.accept(.unavailable)
                } else if sleepTimeToMinute < 60 {
                    howMuchSleepTimeState.accept(.unavailable)
                } else {
                    howMuchSleepTimeState.accept(.available)
                }
            }
            .disposed(by: disposeBag)

        // DefaultDivideConfig로 이동
        input.nextButtonTapped
            .bind(with: self) { owner, void in
                owner.scrollToNext.accept(void)
            }
            .disposed(by: disposeBag)
            
        return Output(
            adjustValue: adjustValue,
            whenIsBedTimeToString: whenIsBedTimeToString,
            whenIsWakeUpTimeToString: whenIsWakeUpTimeToString,
            howMuchSleepTimeToString: howMuchSleepTimeToString,
            howMuchSleepTimeState: howMuchSleepTimeState
        )
    }

}

extension DefaultTimeConfigViewModel {

    // 5분 단위로만 설정 가능하게 해주는 메소드
    func adjustValue(value: inout CGFloat) {    // -> inout 때문에 상당히 골치 아프다
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
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
