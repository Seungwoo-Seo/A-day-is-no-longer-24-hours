//
//  DayDivideContentViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import Foundation

final class DayDivideContentViewModel {
    var todoSectionList = Observable<[TodoSection]>([])

    deinit {
        print(#function)
    }

}

// MARK: - 비즈니스: CollectionView
extension DayDivideContentViewModel {

    func getTodoSection(section: Int) -> TodoSection {
        return todoSectionList.value[section]
    }

}
