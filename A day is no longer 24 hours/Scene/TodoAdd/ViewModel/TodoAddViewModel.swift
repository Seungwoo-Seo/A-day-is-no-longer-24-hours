//
//  TodoAddViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import RealmSwift
import UIKit

final class TodoAddViewModel {
    // MARK: - Sub ViewModel
    let dayDividedSelectViewModel = DayDividedSelectViewModel()
    let todoTimeSettingViewModel = TodoTimeSettingViewModel()

    // MARK: - DI
    let selectedDate: Observable<Date>


    // MARK: - Just Scene
    lazy var viewControllers = Observable(
        [
            DayDividedSelectViewController(
                viewModel: dayDividedSelectViewModel
            ),
            TodoTimeSettingViewController(
                viewModel: todoTimeSettingViewModel
            )
        ]
    )

    // MARK: - Event
    let scrollToPage = Observable(false)


    // MARK: - Realm
    let realm = try! Realm()

    // MARK: - Init
    init(selectedDate: Observable<Date>) {
        self.selectedDate = selectedDate
        bind()
    }

    private func bind() {
        // 선택한 날짜가 전달되면
        selectedDate.bind { [weak self] (date) in
            guard let self else {return}
            self.fetchDividedValue(of: date)
        }

        dayDividedSelectViewModel.nextButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.fetchDividedDay()
            self.scrollToPage.value.toggle()
        }
    }

}

// MARK: - PageboyViewControllerDataSource
extension TodoAddViewModel {

    var numberOfViewControllers: Int {
        return viewControllers.value.count
    }

    func viewControllerCorresponding(
        to index: Int
    ) -> UIViewController {
        return viewControllers.value[index]
    }
}

// MARK: - 비즈니스
private extension TodoAddViewModel {

    /// 하루를 나눈 값을 가져오기
    func fetchDividedValue(of date: Date) {
        // 사용한 적 있다면 UseDay Table에 존재
        if let useDay = realm.objects(UseDay.self).where({$0.date == date}).first {
            // TODO: useDay.divideValue 사용해서 로직 짜야함


        // 사용한 적이 없다면 UseDay Table에 존재하지 않음
        } else {
            // 최초 생성이라고 볼 수 있지
            // 사용한 적이 없다면 DefaultDayConfiguration Table에 record를 활용해서 Flow를 구성해야함
            guard let defaultDayConfig = realm.objects(DefaultDayConfiguration.self).first else {
                print("defaultDayConfig 레코드 없음, 무조건 있어야 하는데 없네")
                return
            }

            // 어떤 분기에 Todo를 추가하려는건지 알 수 있게 dividedValue를 전달
            dayDividedSelectViewModel.dividedValue.value = defaultDayConfig.dividedValue
        }
    }

    /// 특정 나눠진 날 가져오기
    func fetchDividedDay() {
        let selectedDiviedDay = dayDividedSelectViewModel.selectedDiviedDay

        if let useDay = realm.objects(UseDay.self).where({$0.date == selectedDate.value}).first {

        } else {
            guard let defaultDayConfig = realm.objects(DefaultDayConfiguration.self).first else {
                print("defaultDayConfig 레코드 없음, 무조건 있어야 하는데 없네")
                return
            }

            guard let dividedDay = defaultDayConfig.dividedDayList.where({$0.day == selectedDiviedDay}).first else {
                print("dividedDay 레코드 없음")
                return
            }

            self.todoTimeSettingViewModel.dividedDay.value = dividedDay
            print(#function)
        }
    }

}
