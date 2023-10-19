//
//  DayDividedSelectViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import Foundation
import RealmSwift

final class DayDividedSelectViewModel {

    let selectedDate: Observable<Date>

    // MARK: - bind from DayDividedSelectViewController
    let divideValue = Observable(1)

    // MARK: - Realm
    let realm = try! Realm()


    // MARK: - Init
    init(selectedDate: Date) {
        self.selectedDate = Observable(selectedDate)
        bind()
    }

    private func bind() {
        selectedDate.bind { [weak self] (date) in
            guard let self else {return}
            self.updateDivideValue(date: date)
        }
    }

    private func updateDivideValue(date: Date) {
        // 해당 날짜를 사용하고 있는 날짜인지 확인하기 위해서 UseDay Table에 검색하고
        if let divideValue = realm.objects(UseDay.self).where({ $0.date == date }).first?.divideValue {
            // 있다면 최초 생성 아님
            self.divideValue.value = divideValue

        } else {
            // UseDay Table에 없다면 최초 생성인거고
            guard let dividedValue = realm.objects(DefaultDayConfiguration.self).first?.dividedValue else {
                print("DayDividedSelectViewModel에 test메서드 내부 ===> dividedValue 없음")
                return
            }

            self.divideValue.value = dividedValue
        }
    }

}

// MARK: - UIPickerViewDataSource
extension DayDividedSelectViewModel {

    var numberOfComponents: Int {
        return 1
    }

    var numberOfRowsInComponent: Int {
        return divideValue.value
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
        print("row --> \(row)")
//        currentDivideValue.value = divideValueList.value[row]
    }

}
