//
//  ScheduleViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import Foundation
import RealmSwift

extension Date {
    var toString: String {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyyMMdd"
        return format.string(from: self)
    }
}

final class ScheduleViewModel {
    // MARK: - Sub ViewModel
    lazy var dayDivideContainerViewModel = DayDivideContainerViewModel(
        selectedYmd: selectedYmd.value
    )

    // 선택한 년월일
    let selectedYmd = CustomObservable(Date().toString)

    init() {
        selectedYmd.bind { [weak self] (ymd) in
            guard let self else {return}

            self.dayDivideContainerViewModel.selectedYmd.value = ymd
        }
    }


    // MARK: - Just Scene
    var currentMonth = CustomObservable("")

}

// MARK: - 비즈니스: Calendar
extension ScheduleViewModel {

    func updateCurrentPage(
        date: Date,
        isMonth: Bool = false
    ) {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyy년 M월"

        if isMonth {
            currentMonth.value = format.string(from: date)
        } else {
            guard let currentDate = Calendar.current.date(byAdding: .day, value: 3, to: date) else {
                return
            }
            currentMonth.value = format.string(from: currentDate)
        }
    }

}
