//
//  DayDivideContainerViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/17.
//

import RealmSwift
import UIKit

final class DayDivideContainerViewModel {
    // MARK: Sub ViewModel
    let dayDividedContentViewModel = DayDivideContentViewModel()

    // MARK: Just Scene
    let viewControllers: Observable<[DayDivideContentViewController]> = Observable([])

    // MARK: - Event
    // 캘린더에서 날짜를 선택했을 떄
    let didSelectDate: Observable<Date?> = Observable(nil)



    let realm = try! Realm()


    // MARK: - Init
    init() {
        // 캘린더에서 날짜를 선택할 때마다
        didSelectDate.bind { [weak self] (bool) in
            guard let self else {return}
            // 해당 날짜가 커스텀 되어 있는지 확인하고
            // 커스텀 되어 있지 않다면
            // DefaultDayConfiguration에 데이터를 활용한다.
            // Get all todos in the realm


            // -- 커스텀 되어 있지 않을 때
            guard let defaultDayConfig = self.realm.objects(DefaultDayConfiguration.self).first else {return}

            var viewControllers: [DayDivideContentViewController] = []
            for _ in 0..<defaultDayConfig.dividedValue {

                let viewModel = DayDivideContentViewModel()

                let vc = DayDivideContentViewController(
                    viewModel: viewModel
                )
                vc.view.backgroundColor = Constraints.Color.black
                viewControllers.append(vc)
            }

            self.viewControllers.value = viewControllers
        }
    }

}

extension DayDivideContainerViewModel {

    var numberOfViewControllers: Int {
        return viewControllers.value.count
    }

    func viewController(index: Int) -> UIViewController {
        return viewControllers.value[index]
    }

}
