//
//  UseDay.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import Foundation
import RealmSwift

final class UseDay: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: Date
    @Persisted var isDefault: Bool
    @Persisted var whenIsBedTime: Int?
    @Persisted var whenIsWakeUpTime: Int?
    @Persisted var howMuchLifeTime: Int?
    @Persisted var divideValue: Int?
    @Persisted var todoList = List<TodoDTO>()

    convenience init(
        _id: ObjectId,
        date: Date,
        isDefault: Bool,
        whenIsBedTime: Int? = nil,
        whenIsWakeUpTime: Int? = nil,
        howMuchLifeTime: Int? = nil,
        divideValue: Int? = nil
    ) {
        self.init()
        self._id = _id
        self.date = date
        self.isDefault = isDefault
        self.whenIsBedTime = whenIsBedTime
        self.whenIsWakeUpTime = whenIsWakeUpTime
        self.howMuchLifeTime = howMuchLifeTime
        self.divideValue = divideValue
    }

}

//enum TodoDTOKind: String, PersistableEnum {
//    case simple
//    case detail
//}

final class TodoDTO: EmbeddedObject {
    @Persisted var whenIsStart: Int
    @Persisted var whenIsEnd: Int
    @Persisted var category: String
    @Persisted var subTitle: String?
    @Persisted var isComplete: Bool
    @Persisted var detailTodoList: List<DetailTodoDTO>

    convenience init(
        whenIsStart: Int,
        whenIsEnd: Int,
        category: String,
        subTitle: String?,
        isComplete: Bool,
        detailTodoList: List<DetailTodoDTO>
    ) {
        self.init()
        self.whenIsStart = whenIsStart
        self.whenIsEnd = whenIsEnd
        self.category = category
        self.subTitle = subTitle
        self.isComplete = isComplete
        self.detailTodoList = detailTodoList
    }
}

final class DetailTodoDTO: EmbeddedObject {
    @Persisted var title: String
    @Persisted var isComplete: Bool

    convenience init(title: String, isComplete: Bool) {
        self.init()
        self.title = title
        self.isComplete = isComplete
    }
}
