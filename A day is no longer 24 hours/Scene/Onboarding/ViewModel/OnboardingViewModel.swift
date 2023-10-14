//
//  OnboardingViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import RealmSwift
import Foundation

final class OnboardingViewModel {
    let sleepTimeViewModel: SleepTimeViewModel
    let dateDivideViewModel: DateDivideViewModel

    /// 생활 시간을 "분"으로 변경한 값
    let lifeTime: Observable<Int?> = Observable(nil)

    // MARK: - Init
    private init(sleepTimeViewModel: SleepTimeViewModel, dateDivideViewModel: DateDivideViewModel) {
        self.sleepTimeViewModel = sleepTimeViewModel
        self.dateDivideViewModel = dateDivideViewModel
    }

    convenience init() {
        self.init(
            sleepTimeViewModel: SleepTimeViewModel(),
            dateDivideViewModel: DateDivideViewModel()
        )

        lifeTime.bind { lifeTime in
            guard let lifeTime else {return}
            self.dateDivideViewModel.lifeTime.value = lifeTime
        }

        sleepTimeViewModel.nextButtonTapped.bind(
            subscribeNow: false
        ) {  _ in
            let sleepTime = self.sleepTimeViewModel.sleepTime.value


            // 여기서 24 -> 수면시간 해야함
            // 전달 받은 수면시간(Date)을 분으로 바꾸고
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: sleepTime)
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            let sleepTimeToMinute = hour * 60 + minute

            // 하루를 분으로 바꿔서
            let dayToMinute = 24 * 60

            let lifeTime = dayToMinute - sleepTimeToMinute

            self.dateDivideViewModel.lifeTime.value = lifeTime
            self.lifeTime.value = lifeTime
            print("lifeTime -> ", lifeTime)
        }

        dateDivideViewModel.dateDivideSelectButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            let bedTime = self.sleepTimeViewModel.bedTime.value
            let wakeUpTime = self.sleepTimeViewModel.wakeUpTime.value
            let sleepTime = self.sleepTimeViewModel.sleepTime.value
            let dayDivideValue = self.dateDivideViewModel.dayDivideValue.value
        }
    }

}
