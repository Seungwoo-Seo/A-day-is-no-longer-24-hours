//
//  OnboardingViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import RealmSwift
import Foundation

final class OnboardingViewModel {
    // MARK: Sub ViewModel
    let defaultTimeConfigViewModel = DefaultTimeConfigViewModel()
    let dateDivideViewModel = DefaultDivideCofigViewModel()

    // MARK: - Just Scene
    /// createDefaultConfigurationTable 메서드의 유효성
    let createDefaultDayConfigurationTableValidity = Observable(false)

    // MARK: - Realm
    let realm = try! Realm()

    // MARK: - Init
    init() {
        defaultTimeConfigViewModel.howMuchLivingTime.bind { [weak self] (lifeHourToMinute) in
            guard let self else {return}
            self.dateDivideViewModel.howMuchLivingTime.value = lifeHourToMinute
        }

        dateDivideViewModel.divideAndStartButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.todayTomorrowOrTomorrowTomorrow()
        }
    }
    
}

private extension OnboardingViewModel {

    func todayTomorrowOrTomorrowTomorrow() {
        let whenIsBedTime = defaultTimeConfigViewModel.whenIsBedTime.value
        let whenIsWakeUpTime = defaultTimeConfigViewModel.whenIsWakeUpTime.value
        let howMuchSleepTime = defaultTimeConfigViewModel.howMuchSleepTime.value
        let howMuchLivingTime = dateDivideViewModel.howMuchLivingTime.value
        let dividedValue = dateDivideViewModel.currentDivideValue.value

        // DefaultTimeConfigViewModel에서 24시간을 추가한 계산을 하면 slider 제대로 동작 안될 듯
        // 일단 여기서 해보자

        // 오늘 자서 다음날에 일어나는 경우
        if whenIsBedTime > whenIsWakeUpTime {
            // 그대로 계산하면 되고
            createDefaultDayConfiguration(
                whenIsBedTime: whenIsBedTime,
                whenIsWakeUpTime: whenIsWakeUpTime,
                howMuchSleepTime: howMuchSleepTime,
                howMuchLivingTime: howMuchLivingTime,
                dividedValue: dividedValue
            )
        // 다음날 자서 다음날 일어나는 경우
        } else {
            // 1440(24시)를 whenIsBedTime에 더해야 한다
            let tmWhenIsBedTime = whenIsBedTime + 1440
            let tmWhenIsWakeUpTime = whenIsWakeUpTime
            let tmHowMuchLivingTime = tmWhenIsBedTime - tmWhenIsWakeUpTime
            let tmHowMuchSleepTime = tmWhenIsWakeUpTime - (tmWhenIsBedTime - 1440)

            createDefaultDayConfiguration(
                whenIsBedTime: tmWhenIsBedTime,
                whenIsWakeUpTime: tmWhenIsWakeUpTime,
                howMuchSleepTime: tmHowMuchSleepTime,
                howMuchLivingTime: tmHowMuchLivingTime,
                dividedValue: dividedValue
            )
        }
        // 취침 시각과 기상 시각이 같은 경우는 없다
        // 두 시각이 같다면 애초에 이 메서드 호출 안되게 해놨음
    }

    func createDefaultDayConfiguration(
        whenIsBedTime: Int,
        whenIsWakeUpTime: Int,
        howMuchSleepTime: Int,
        howMuchLivingTime: Int,
        dividedValue: Int
    ) {
        let defaultDayConfig = DefaultDayConfiguration(
            whenIsBedTime: whenIsBedTime,
            whenIsWakeUpTime: whenIsWakeUpTime,
            howMuchSleepTime: howMuchSleepTime,
            howMuchLivingTime: howMuchLivingTime,
            dividedValue: dividedValue
        )

        for dividedDay in 0..<dividedValue {
            let dividedDayHowMuchLivingTime = howMuchLivingTime / dividedValue

            let whenIsStartTime = whenIsWakeUpTime + (dividedDayHowMuchLivingTime * dividedDay)
            let whenIsEndTime = whenIsWakeUpTime + (dividedDayHowMuchLivingTime * (dividedDay + 1))

            defaultDayConfig.dividedDayList.append(
                DividedDay(
                    day: dividedDay,
                    whenIsStartTime: whenIsStartTime,
                    whenIsEndTime: whenIsEndTime,
                    howMuchLivingTime: dividedDayHowMuchLivingTime
                )
            )
        }

        do {
            try realm.write {
                if let defaultDayConfigDelete = realm.objects(DefaultDayConfiguration.self).first {
                    realm.delete(defaultDayConfigDelete)
                    realm.add(defaultDayConfig)
                    createDefaultDayConfigurationTableValidity.value = true
                } else {
                    // 최초 생성
                    realm.add(defaultDayConfig)
                    createDefaultDayConfigurationTableValidity.value = true
                    UserDefaultsManager.shared.isChange = true
                    print("add 성공")
                }
            }
        } catch {
            createDefaultDayConfigurationTableValidity.value = false
            UserDefaultsManager.shared.isChange = false
            print("add 실패")
        }
    }

}
