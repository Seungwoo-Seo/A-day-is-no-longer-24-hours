//
//  ScheduleViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import Foundation

final class ScheduleViewModel {

    var todoSectionList = Observable<[TodoSection]>([])

    func getTodoSection(section: Int) -> TodoSection {
        return todoSectionList.value[section]
    }

}
