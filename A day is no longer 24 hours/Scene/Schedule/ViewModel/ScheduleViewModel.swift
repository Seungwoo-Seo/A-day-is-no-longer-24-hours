//
//  ScheduleViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import Foundation
import RealmSwift

final class ScheduleViewModel {
    // MARK: - ViewModel
    let dayDivideContainerViewModel = DayDivideContainerViewModel()


    var currentMonth = Observable<String>("")

    let realm = try! Realm()

}

// MARK: - 비즈니스: Calendar
extension ScheduleViewModel {

    func currentPage(date: Date, isMonth: Bool = false) -> String {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyy년 M월"

        if isMonth {
            return format.string(from: date)
        } else {
            guard let currentDate = Calendar.current.date(byAdding: .day, value: 3, to: date) else {
                return ""
            }
            return format.string(from: currentDate)
        }
    }

}
