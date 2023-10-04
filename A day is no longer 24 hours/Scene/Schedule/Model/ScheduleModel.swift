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

    private let _id = UUID()
}

struct Todo: Hashable {
    let title: String
    private let _id = UUID()
}

enum TodoKind {
    case detail
    case simple
}
