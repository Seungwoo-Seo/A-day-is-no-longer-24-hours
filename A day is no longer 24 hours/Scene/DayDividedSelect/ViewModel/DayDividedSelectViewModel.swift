//
//  DayDividedSelectViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import Foundation

final class DayDividedSelectViewModel {

    // MARK: - bind from DayDividedSelectViewController
    let dividedValue = CustomObservable(0)

    // MARK: - bind from TodoAddContainerViewController
    let prevButtonTapped = CustomObservable(false)
    let nextButtonTapped = CustomObservable(false)

    // MARK: - Result
    /// 선택한 나눈 날
    let selectedDiviedDay = CustomObservable(0)

}

// MARK: - UIPickerViewDataSource
extension DayDividedSelectViewModel {

    var numberOfComponents: Int {
        return 1
    }

    var numberOfRowsInComponent: Int {
        return dividedValue.value
    }
}


// MARK: - UIPickerViewDelegate
extension DayDividedSelectViewModel {

    func attributedTitleForRow(_ row: Int) -> NSAttributedString {
        return NSAttributedString(
            string: "Day \(row + 1)",
            attributes: [.foregroundColor: Constraints.Color.white]
        )
    }

    func didSelectRow(_ row: Int) {
        selectedDiviedDay.value = row
    }

}
