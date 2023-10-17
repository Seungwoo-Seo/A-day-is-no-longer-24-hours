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
            self.createDefaultDayConfigurationTable()
        }
    }
    
}

private extension OnboardingViewModel {

    func createDefaultDayConfigurationTable() {
        let whenIsBedTime = defaultTimeConfigViewModel.whenIsBedTime.value
        let whenIsWakeUpTime = defaultTimeConfigViewModel.whenIsWakeUpTime.value
        let howMuchSleepTime = defaultTimeConfigViewModel.howMuchSleepTime.value
        let howMuchLivingTime = dateDivideViewModel.howMuchLivingTime.value

        let dividedValue = dateDivideViewModel.currentDivideValue.value

        let defaultDayConfig = DefaultDayConfiguration(
            whenIsBedTime: whenIsBedTime,
            whenIsWakeUpTime: whenIsWakeUpTime,
            howMuchSleepTime: howMuchSleepTime,
            howMuchLivingTime: howMuchLivingTime,
            dividedValue: dividedValue
        )

        do {
            try realm.write {
                realm.add(defaultDayConfig)
                createDefaultDayConfigurationTableValidity.value = true
                print("add 성공")
            }
        } catch {
            createDefaultDayConfigurationTableValidity.value = false
            print("add 실패")
        }
        print("add 다음 찍혀야함")
    }

}
