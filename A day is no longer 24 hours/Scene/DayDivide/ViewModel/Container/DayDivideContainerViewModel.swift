//
//  DayDivideContainerViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/17.
//

import RealmSwift
import UIKit

final class DayDivideContainerViewModel {
    // MARK: Just Scene
    let viewControllers: Observable<[DayDivideContentViewController]> = Observable([])

    // MARK: - 상위 ViewModel에서 데이터 전달, self에서 바인딩
    // 캘린더에서 날짜를 선택했을 떄
    let selectedYmd: Observable<String>

    // MARK: - Repository
    let task = RealmRepository()

    // MARK: - Init
    init(selectedYmd: String) {
        self.selectedYmd = Observable(selectedYmd)
        self.selectedYmd.bind { [weak self] (ymd) in
            guard let self else {return}

            self.updateViewControllers(to: ymd)
        }
    }

}

// MARK: - PageboyViewControllerDataSource
extension DayDivideContainerViewModel {

    var numberOfViewControllers: Int {
        return viewControllers.value.count
    }

    func viewController(index: Int) -> UIViewController {
        return viewControllers.value[index]
    }

}

// MARK: - TMBarDataSource
extension DayDivideContainerViewModel {

    func barItemTitle(at index: Int) -> String {
        return "day \(index + 1)"
    }
}

private extension DayDivideContainerViewModel {

    func updateViewControllers(to ymd: String) {
        // 먼저 선택한 날짜에 해당하는 UseDay 레코드가 없다면
        // 일단 DefaultDayConfiguration을 기반으로 보여주기만 해야한다.
        switch task.state(of: ymd) {
//        case .onlyDivided(let useDay):
//            var viewControllers: [DayDivideContentViewController] = []
//
//            for dividedDay in useDay.dividedDayList {
//                let viewModel = DayDivideContentViewModel(
//                    selectedYmd: selectedYmd.value,
//                    dividedDay: dividedDay
//                )
//                let vc = DayDivideContentViewController(viewModel: viewModel)
//                viewControllers.append(vc)
//            }
//            self.viewControllers.value = viewControllers
//            print("onlyDivided")

        case .stableAdded(let useDay):
            var viewControllers: [DayDivideContentViewController] = []

            for dividedDay in useDay.dividedDayList {
                let viewModel = DayDivideContentViewModel(
                    selectedYmd: selectedYmd.value,
                    dividedDayStruct: dividedDay.toDividedDayStruct
                )
                let vc = DayDivideContentViewController(viewModel: viewModel)
                viewControllers.append(vc)
            }
            self.viewControllers.value = viewControllers
            print("stableAdded")

        case .noting(let defaultDayConfig):
            var viewControllers: [DayDivideContentViewController] = []

            // 여기서 어차피 보여주기만 하면 되잖아
            for dividedDay in defaultDayConfig.dividedDayList {
                let viewModel = DayDivideContentViewModel(
                    selectedYmd: selectedYmd.value,
                    dividedDayStruct: dividedDay.toDividedDayStruct
                )
                let vc = DayDivideContentViewController(viewModel: viewModel)
                viewControllers.append(vc)
            }
            self.viewControllers.value = viewControllers

        case .never:
            fatalError("너는 반드시 온보딩 화면에서 받았을텐데 너가 없다는건 뭔가 아주 단단히 잘못된 것이다")
        }
    }

}
