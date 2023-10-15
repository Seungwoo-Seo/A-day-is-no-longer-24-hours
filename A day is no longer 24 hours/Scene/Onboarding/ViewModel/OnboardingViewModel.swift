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
    let sleepTimeViewModel: SleepTimeViewModel
    let dateDivideViewModel: DateDivideViewModel

    // MARK: - Just Scene
    /// createDefaultConfigurationTable 메서드의 유효성
    let createDefaultConfigurationTableValidity: Observable<Bool>

    // MARK: - Realm
    let realm = try! Realm()

    // MARK: - Init
    private init(
        sleepTimeViewModel: SleepTimeViewModel,
        dateDivideViewModel: DateDivideViewModel,
        createDefaultConfigurationTableValidity: Observable<Bool>
    ) {
        self.sleepTimeViewModel = sleepTimeViewModel
        self.dateDivideViewModel = dateDivideViewModel
        self.createDefaultConfigurationTableValidity = createDefaultConfigurationTableValidity
    }

    convenience init() {
        self.init(
            sleepTimeViewModel: SleepTimeViewModel(),
            dateDivideViewModel: DateDivideViewModel(),
            createDefaultConfigurationTableValidity: Observable(false)
        )

        sleepTimeViewModel.lifeHourToMinute.bind { [weak self] (lifeHourToMinute) in
            guard let self else {return}
            self.dateDivideViewModel.lifeHourToMinute.value = lifeHourToMinute
        }

        dateDivideViewModel.divideAndStartButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.createDefaultConfigurationTable()
        }
    }

}

private extension OnboardingViewModel {

    func createDefaultConfigurationTable() {
        let bedTime = sleepTimeViewModel.bedTime.value
        let wakeUpTime = sleepTimeViewModel.wakeUpTime.value
        let sleepHourToMinute = sleepTimeViewModel.sleepHourToMinute.value
        let lifeHourToMinute = dateDivideViewModel.lifeHourToMinute.value
        let dayDivideValue = dateDivideViewModel.currentDivideValue.value

        let defaultConfiguration = DefaultConfiguration(
            bedTime: bedTime,
            wakeUpTime: wakeUpTime,
            sleepHourToMinute: sleepHourToMinute,
            lifeHourToMinute: lifeHourToMinute,
            dividedValue: dayDivideValue
        )

        do {
            try realm.write {
                realm.add(defaultConfiguration)
                createDefaultConfigurationTableValidity.value = true
                print("add 성공")
            }
        } catch {
            createDefaultConfigurationTableValidity.value = false
            print("add 실패")
        }
        print("add 다음 찍혀야함")
    }

}
