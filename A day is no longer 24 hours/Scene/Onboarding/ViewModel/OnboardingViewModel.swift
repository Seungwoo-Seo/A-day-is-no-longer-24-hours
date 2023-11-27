//
//  OnboardingViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

final class OnboardingViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    // MARK: Sub ViewModel
    let defaultTimeConfigViewModel = DefaultTimeConfigViewModel()
    let defaultDivideCofigViewModel = DefaultDivideCofigViewModel()

    lazy var viewControllers = [
        DefaultTimeConfigViewController(viewModel: defaultTimeConfigViewModel),
        DefaultDivideConfigViewController(viewModel: defaultDivideCofigViewModel)
    ]

    // MARK: - Just Scene
    /// createDefaultConfigurationTable 메서드의 유효성
    let createDefaultDayConfigurationTableValidity = CustomObservable(false)

    // MARK: - Realm
    let realm = try! Realm()

    struct Input {

    }

    struct Output {
        let scrollToDefaultDivideConfig: PublishRelay<Void>
        let backScrollToDefaultTimeConfig: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        let scrollToDefaultDivideConfig = PublishRelay<Void>()
        let backScrollToDefaultTimeConfig = PublishRelay<Void>()

        let test = defaultTimeConfigViewModel.scrollToNext
            .share()

        test
            .bind(with: self) { owner, void in
                scrollToDefaultDivideConfig.accept(void)
            }
            .disposed(by: disposeBag)

        test
            .withLatestFrom(defaultTimeConfigViewModel.howMuchLivingTime)
            .distinctUntilChanged()
            .bind(with: self) { owner, livingTimeToMinute in
                owner.defaultDivideCofigViewModel.howMuchLivingTime.accept(livingTimeToMinute)
            }
            .disposed(by: disposeBag)


        defaultDivideCofigViewModel.scrollToPrev
            .bind(with: self) { owner, void in
                backScrollToDefaultTimeConfig.accept(void)
            }
            .disposed(by: disposeBag)

        return Output(
            scrollToDefaultDivideConfig: scrollToDefaultDivideConfig,
            backScrollToDefaultTimeConfig: backScrollToDefaultTimeConfig
        )
    }

    // MARK: - Init
    init() {
//        defaultTimeConfigViewModel.howMuchLivingTime.bind { [weak self] (lifeHourToMinute) in
//            guard let self else {return}
//            self.dateDivideViewModel.howMuchLivingTime.value = lifeHourToMinute
//        }

//        dateDivideViewModel.divideAndStartButtonTapped.bind(
//            subscribeNow: false
//        ) { [weak self] _ in
//            guard let self else {return}
//            self.todayTomorrowOrTomorrowTomorrow()
//        }

        defaultTimeConfigViewModel.scrollToNext
            .bind(with: self) { owner, void in

            }
            .disposed(by: disposeBag)
    }
    
}

private extension OnboardingViewModel {

    func todayTomorrowOrTomorrowTomorrow() {
        let whenIsBedTime = defaultTimeConfigViewModel.whenIsBedTime.value
        let whenIsWakeUpTime = defaultTimeConfigViewModel.whenIsWakeUpTime.value
        let howMuchSleepTime = defaultTimeConfigViewModel.howMuchSleepTime.value
        let howMuchLivingTime = defaultDivideCofigViewModel.howMuchLivingTime.value
        let dividedValue = defaultDivideCofigViewModel.currentDivideValue.value

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
