//
//  TodoTimeSettingViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import Foundation

final class TodoTimeSettingViewModel {

    let dividedDay: Observable<DividedDay?> = Observable(nil)

    let minuteList = Array(0...59)

    // MARK: - Init
    init() {

    }

}

// MARK: - UIPickerViewDataSource
extension TodoTimeSettingViewModel {

    var numberOfComponents: Int {
        return 2
    }

    func numberOfRowsInComponent(
        _ component: Int,
        tag: Int
    ) -> Int {
        guard let dividedDay = dividedDay.value else {
            return 0
        }

        if tag == 0{
            if component == 0 {
                return dividedDay.whenIsUseHourList.count
            } else {
                return minuteList.count
            }
        } else {
            if component == 0 {
                return dividedDay.livingHourSplitList.count
            } else {
                return minuteList.count
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
extension TodoTimeSettingViewModel {

    func attributedTitleForRow(
        _ row: Int,
        forComponent component: Int,
        tag: Int
    ) -> NSAttributedString {
        guard let dividedDay = dividedDay.value else {
            return NSAttributedString()
        }

        if tag == 0 {
            print("-1")
            if component == 0 {
                return NSAttributedString(
                    string: "\(dividedDay.whenIsUseHourList[row]) 시",
                    attributes: [.foregroundColor: Constraints.Color.black]
                )
            } else {
                return NSAttributedString(
                    string: "\(minuteList[row]) 분",
                    attributes: [.foregroundColor: Constraints.Color.black]
                )
            }
        } else {
            print("-2")
            if component == 0 {
                return NSAttributedString(
                    string: "\(dividedDay.livingHourSplitList[row]) 시간",
                    attributes: [.foregroundColor: Constraints.Color.black]
                )
            } else {
                return NSAttributedString(
                    string: "\(minuteList[row]) 분",
                    attributes: [.foregroundColor: Constraints.Color.black]
                )
            }
        }
    }

    func didSelectRow(_ row: Int) {
        guard let dividedDay = dividedDay.value else {
            return
        }
        print("row --> \(dividedDay.whenIsUseHourList[row])")
//        currentDivideValue.value = divideValueList.value[row]
    }

}
