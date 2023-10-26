//
//  TodoDTO.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/23.
//

import Foundation
import RealmSwift

enum TodoKind: String, PersistableEnum {
    case startStandard
    case simple
    case detail
    case endStandard
}

struct TodoStruct: Hashable {
    let id: UUID
    let kind: TodoKind
    let whenIsStartTime: Int
    let whenIsEndTime: Int
    let category: String
    let subTitle: String?
    var isComplete: Bool
    let detailTodoList: [DetailTodoStruct]

    var startTime: (startHour: Int, startMinute: Int) {
        let startHour = whenIsStartTime / 60
        let startMinute = whenIsStartTime % 60
        return (startHour, startMinute)
    }

    var endTime: (endHour: Int, endMinute: Int) {
        let endHour = whenIsEndTime / 60
        let endMinute = whenIsEndTime % 60
        return (endHour, endMinute)
    }

    var startTimeToString: String {
        let startHour = startTime.startHour
        let startMinute = startTime.startMinute

        if startHour == 0 {
            if startMinute == 0 {   // ==> 24시가 기상 시간일 경우
                return "00:00"
            } else {
                if startMinute < 10 {
                    return "00:0\(startMinute)"
                } else {
                    return "00:\(startMinute)"
                }
            }
        } else {
            if startMinute == 0 {
                if startHour < 10 {
                    return "0\(startHour):00"
                } else {
                    return "\(startHour):00"
                }
            } else {
                if startHour < 10 {
                    if startMinute < 10 {
                        return "0\(startHour):0\(startMinute)"
                    } else {
                        return "0\(startHour):\(startMinute)"
                    }
                } else {
                    if startMinute < 10 {
                        return "\(startHour):0\(startMinute)"
                    } else {
                        return "\(startHour):\(startMinute)"
                    }
                }
            }
        }
    }

    var endTimeToString: String {
        let endHour = endTime.endHour
        let endMinute = endTime.endMinute

        // MARK: - endHour는 0이 나올 수 없지 않나 아마 1440(24)이 더해져서 0이 나올 수가 없을텐데..
        // 아 대가리 안돌아가네;
        if endHour == 0 {
            if endMinute == 0 {
                return "24:00"
            } else {
                if endMinute < 10 {
                    return "24:0\(endMinute)"
                } else {
                    return "24:\(endMinute)"
                }
            }
        } else {
            if endMinute == 0 {
                if endHour < 10 {
                    return "0\(endHour):00"
                } else {
                    return "\(endHour):00"
                }
            } else {
                if endHour < 10 {
                    if endMinute < 10 {
                        return "0\(endHour):0\(endMinute)"
                    } else {
                        return "0\(endHour):\(endMinute)"
                    }
                } else {
                    if endMinute < 10 {
                        return "\(endHour):0\(endMinute)"
                    } else {
                        return "\(endHour):\(endMinute)"
                    }
                }
            }
        }
    }


}

final class Todo: EmbeddedObject {
    @Persisted var id = UUID()
    @Persisted var kind: TodoKind
    @Persisted var whenIsStartTime: Int
    @Persisted var whenIsEndTime: Int
    @Persisted var category: String
    @Persisted var subTitle: String?
    @Persisted var isComplete: Bool
    @Persisted var detailTodoList: List<DetailTodo>

    convenience init(
        kind: TodoKind,
        whenIsStartTime: Int,
        whenIsEndTime: Int,
        category: String,
        subTitle: String?,
        isComplete: Bool = false,
        detailTodoList: [DetailTodo] = []
    ) {
        self.init()
        self.kind = kind
        self.whenIsStartTime = whenIsStartTime
        self.whenIsEndTime = whenIsEndTime
        self.category = category
        self.subTitle = subTitle
        self.isComplete = isComplete
        self.detailTodoList.append(objectsIn: detailTodoList)
    }

    var toTodo: Todo {
        let todo = Todo(
            kind: kind,
            whenIsStartTime: whenIsStartTime,
            whenIsEndTime: whenIsEndTime,
            category: category,
            subTitle: subTitle
        )
        detailTodoList.forEach {
            todo.detailTodoList.append($0.toDetailTodo)
        }

        return todo
    }

    var toTodoStruct: TodoStruct {
        let detailTodoList: [DetailTodoStruct] = detailTodoList.map { $0.toDetailTodoStruct }
        return TodoStruct(
            id: id,
            kind: kind,
            whenIsStartTime: whenIsStartTime,
            whenIsEndTime: whenIsEndTime,
            category: category,
            subTitle: subTitle,
            isComplete: isComplete,
            detailTodoList: detailTodoList
        )
    }

    var startTime: (startHour: Int, startMinute: Int) {
        let startHour = whenIsStartTime / 60
        let startMinute = whenIsStartTime % 60
        return (startHour, startMinute)
    }

    var endTime: (endHour: Int, endMinute: Int) {
        let endHour = whenIsEndTime / 60
        let endMinute = whenIsEndTime % 60
        return (endHour, endMinute)
    }

    var startTimeToString: String {
        let startHour = startTime.startHour
        let startMinute = startTime.startMinute

        if startHour == 0 {
            if startMinute == 0 {   // ==> 24시가 기상 시간일 경우
                return "00:00"
            } else {
                if startMinute < 10 {
                    return "00:0\(startMinute)"
                } else {
                    return "00:\(startMinute)"
                }
            }
        } else {
            if startMinute == 0 {
                if startHour < 10 {
                    return "0\(startHour):00"
                } else {
                    return "\(startHour):00"
                }
            } else {
                if startHour < 10 {
                    if startMinute < 10 {
                        return "0\(startHour):0\(startMinute)"
                    } else {
                        return "0\(startHour):\(startMinute)"
                    }
                } else {
                    if startMinute < 10 {
                        return "\(startHour):0\(startMinute)"
                    } else {
                        return "\(startHour):\(startMinute)"
                    }
                }
            }
        }
    }

    var endTimeToString: String {
        let endHour = endTime.endHour
        let endMinute = endTime.endMinute

        // MARK: - endHour는 0이 나올 수 없지 않나 아마 1440(24)이 더해져서 0이 나올 수가 없을텐데..
        // 아 대가리 안돌아가네;
        if endHour == 0 {
            if endMinute == 0 {
                return "24:00"
            } else {
                if endMinute < 10 {
                    return "24:0\(endMinute)"
                } else {
                    return "24:\(endMinute)"
                }
            }
        } else {
            if endMinute == 0 {
                if endHour < 10 {
                    return "0\(endHour):00"
                } else {
                    return "\(endHour):00"
                }
            } else {
                if endHour < 10 {
                    if endMinute < 10 {
                        return "0\(endHour):0\(endMinute)"
                    } else {
                        return "0\(endHour):\(endMinute)"
                    }
                } else {
                    if endMinute < 10 {
                        return "\(endHour):0\(endMinute)"
                    } else {
                        return "\(endHour):\(endMinute)"
                    }
                }
            }
        }
    }

}

final class DetailTodo: EmbeddedObject {
    @Persisted var text: String
    @Persisted var isComplete: Bool

    convenience init(
        text: String = "",
        isComplete: Bool = false
    ) {
        self.init()
        self.text = text
        self.isComplete = isComplete
    }

    // TODO: 이건 지워야겠찌?
    var toDetailTodo: DetailTodo {
        return DetailTodo(
            text: text,
            isComplete: isComplete
        )
    }

    var toDetailTodoStruct: DetailTodoStruct {
        return DetailTodoStruct(
            text: text,
            isComplete: isComplete
        )
    }
}

struct DetailTodoStruct: Hashable {
    let text: String
    var isComplete: Bool
    let id = UUID()

    var toDetailTodo: DetailTodo {
        return DetailTodo(
            text: text,
            isComplete: isComplete
        )
    }
}
