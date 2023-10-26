//
//  DayDivideContentViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import Foundation
import RealmSwift

final class DayDivideContentViewModel {
    let selectedYmd: String
    let dividedDay: DividedDay

    let todoStructList: Observable<[TodoStruct]> = Observable([])

    // MARK: - Realm
    let task = RealmRepository()

    // MARK: - Init
    init(selectedYmd: String, dividedDay: DividedDay) {
        self.selectedYmd = selectedYmd
        self.dividedDay = dividedDay
        self.todoStructList.value = dividedDay.todoList.map({$0.toTodoStruct}).sorted(by: {
            $0.whenIsStartTime < $1.whenIsStartTime
        })

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(todoListAppended),
            name: NSNotification.Name.todoListAppend,
            object: nil
        )
    }

    @objc
    func todoListAppended() {
        if let dividedDay = task.fetchUseDayRecord(selectedYmd)?.dividedDayList[dividedDay.day] {
            todoStructList.value = dividedDay.todoList.map({ $0.toTodoStruct }).sorted(by: {
                $0.whenIsStartTime < $1.whenIsStartTime
            })
        } else {
            // 없으면 뭐 할 필요 없지 않나?
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.todoListAppend, object: nil)
    }

}

// MARK: - 비즈니스: CollectionView
extension DayDivideContentViewModel {

    func getTodoSection(section: Int) -> TodoStruct {
        return todoStructList.value[section]
    }

}

// MARK: - SimpleTodoHeaderProtocol
extension DayDivideContentViewModel {

    func didTapSimpleTodoHeader(
        _ todo: TodoStruct
    ) {
        if let index = todoStructList.value.firstIndex(of: todo) {
            todoStructList.value.remove(at: index)

            let record = task.fetchUseDayRecord(selectedYmd)

            task.deleteTodo(selectedYmd, dividedValue: dividedDay.day, todoStruct: todo)
        }
    }

}

// MARK: - DetailTodoHeaderProtocol
extension DayDivideContentViewModel {

    func didTapDetailTodoHeader(
        _ todo: TodoStruct
    ) {
        if let index = todoStructList.value.firstIndex(of: todo) {
            todoStructList.value.remove(at: index)
            task.deleteTodo(selectedYmd, dividedValue: dividedDay.day, todoStruct: todo)
        }
    }

    func test(
        isSelected: Bool,
        identifier: Int?,
        append: ([DetailTodoStruct], TodoStruct) -> Void,
        delete: ([DetailTodoStruct]) -> Void
    ) {
        guard let identifier else {return}
        if isSelected {
            delete(todoStructList.value.filter({$0.hashValue == identifier}).first!.detailTodoList)

        } else {
            append(
                todoStructList.value.filter({$0.hashValue == identifier}).first!.detailTodoList,
                todoStructList.value.filter({$0.hashValue == identifier}).first!
            )
        }
    }

}


