//
//  RealmRepository.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/24.
//

import Foundation
import RealmSwift

/// 날짜의 상태를 나타내는 열거형
enum DateState {
    // UseDay Table에 추가되어 있지만 Todo는 한 개도 없고 DefaultDayConfiguration의 dividedValue와 다르게 사용자가 변경한 상태
//    case onlyDivided(useDay: UseDay)

    // Todo가 추가된 상태로 UseDay Table에 추가되어 있는 상태
    case stableAdded(useDay: UseDay)

    // UseDay Table에 추가된 적 없는 상태일 때. DefaultDayConfiguration을 참고해서 보여줄 뿐 아직 아무 것도 설정되어 있지 않은 상태
    case noting(defaultDayConfiguration: DefaultDayConfiguration)

    // DefaultDayConfiguration Table에 단 한개의 레코드가 있어야 하는데 없는 상태 => 사실 절대 있으면 안되는 케이스긴 함
    case never
}

final class RealmRepository {

    let realm = try! Realm()

    func state(of ymd: String) -> DateState {
        if let record = fetchUseDayRecord(ymd) {
            // UseDay Table에 동일한 Date를 가진 레코드가 있을 때 Todo가 0개라면
            // => 해당 날짜는 나누는 것만 커스텀 한 것!
            if record.allDividedDayTodoCount == 0 {
                return .stableAdded(useDay: record)
//                return .onlyDivided(useDay: record)
            } else {
                // 얘는 걍 처리하면 되지 않나?
                return .stableAdded(useDay: record)
            }
        } else {
            // UseDay Table에 동일한 Date를 가진 레코드가 없다면
            // => 해당 날짜는 나누는걸 커스텀하지 않았고 하나의 Todo도 만들지 않은 상태!
            if let record = defaultDayConfiguration {
                return .noting(defaultDayConfiguration: record)
            } else {
                print("너는 절대 없어선 안된다. 무조건 오직 하나의 레코드로 존재해야해")
                return .never
            }
        }
    }

}

// MARK: DefaultDayConfiguration
extension RealmRepository {

    var defaultDayConfiguration: DefaultDayConfiguration? {
        get {
            return realm.objects(DefaultDayConfiguration.self).first
        }
        set {
            do {
                try realm.write {
                    guard let newValue else {return}
                    realm.add(newValue)
                }
            } catch {
                print("realm에 DefaultDayConfiguration 생성 실패")
            }
        }
    }

}

// MARK: - UseDay
extension RealmRepository {

    /// 전달 받은 date와 동일한 date를 가지고 있는 UseDay Table의 레코드를 반환해주는 메서드
    func fetchUseDayRecord(_ ymd: String) -> UseDay? {
        return realm.objects(UseDay.self).where({$0.ymd == ymd}).first
    }

    func deleteTodo(_ ymd: String, dividedValue: Int, todoStruct: TodoStruct) {
        guard let useDayRecord = fetchUseDayRecord(ymd) else {return}

        try! realm.write {
            // Delete the Todo.
            let dividedDay = useDayRecord.dividedDayList[dividedValue]
            if let index = dividedDay.todoList.firstIndex(where: {$0.id == todoStruct.id}) {
                dividedDay.todoList.remove(at: index)
            }
        }
    }

}
