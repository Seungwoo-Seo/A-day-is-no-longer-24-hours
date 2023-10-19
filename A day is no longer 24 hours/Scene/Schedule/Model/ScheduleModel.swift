//
//  ScheduleModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import Foundation

// Todo 생성할 때 섹션을 만드는거지
// 만약 3개로 나눈다면
// 시작 섹션과 끝 섹션은 디폴트로 존재할테니까
struct TodoSection: Hashable {
    let kind: TodoKind
    let startTime: String
    let endTime: String
    let category: String
    let title: String?

    var todoList: [Todo] = []

    var identifier: String {
        return startTime + endTime
    }

    private let _id = UUID()
}

struct Todo: Hashable {
    let title: String
    // 해당 Todo가 어떤 TodoSection에 포함되는지
    let sectionIdentifier: String

    private let _id = UUID()
}

enum TodoKind {
    case startStandard
    case simple
    case detail
    case endStandard
}
