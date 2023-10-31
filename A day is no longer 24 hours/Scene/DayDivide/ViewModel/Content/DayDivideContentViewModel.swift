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
    // TODO: 여기서 Realm Type을 사용하지말고 걍 이 렘 썅 좆같은년은 DTO로 두고 쓰자
    // Hasable해서 DefaultDayConfiguration 업데이트할 때 미리 가지고 있던 dividedDay를 날려버리니까
    // 아래 todoListAppended() 메서드 호출되면 걍 런타임 에러되는 듯 개 ㅈ같네 시빯ㅁㅇㅆㅇㅂㅅㅂㅅ
    let dividedDayStruct: DividedDayStruct

    let todoStructList: Observable<[TodoStruct]> = Observable([])

    // MARK: - Realm
    let task = RealmRepository()

    // MARK: - Init
    init(selectedYmd: String, dividedDayStruct: DividedDayStruct) {
        self.selectedYmd = selectedYmd
        self.dividedDayStruct = dividedDayStruct
        self.todoStructList.value = dividedDayStruct.todoList.sorted(by: {$0.whenIsStartTime < $1.whenIsStartTime})

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(todoListAppended),
            name: NSNotification.Name.todoListAppend,
            object: nil
        )
    }

    @objc
    func todoListAppended() {
        if let dividedDay = task.fetchUseDayRecord(selectedYmd)?.dividedDayList[dividedDayStruct.day] {
            todoStructList.value = dividedDay.toDividedDayStruct.todoList.sorted(by: {$0.whenIsStartTime < $1.whenIsStartTime})
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

//            let record = task.fetchUseDayRecord(selectedYmd)

            task.deleteTodo(selectedYmd, dividedValue: dividedDayStruct.day, todoStruct: todo)
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
            task.deleteTodo(selectedYmd, dividedValue: dividedDayStruct.day, todoStruct: todo)
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


