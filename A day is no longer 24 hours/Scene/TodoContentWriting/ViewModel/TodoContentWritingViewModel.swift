//
//  TodoContentWritingViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import Foundation

typealias TodoContent = (category: String, detailTodoStructList: [DetailTodoStruct])

final class TodoContentWritingViewModel {
    // 카테고리 - 필수
    var category: String?

    // MARK: - bind from TodoContentWritingViewController
    // 현재 detailTodo 갯수 => 즉, 화면에 추가된 textField Cell 갯수 - 옵션
    // 여기선 itemIdentifier를 Class로 사용해야함
    let detailTodoList: Observable<[DetailTodo]> = Observable([])

    // MARK: - bind from TodoAddContainerViewController
    let prevButtonTapped = Observable(false)
    let addButtonTapped = Observable(false)

    // MARK: - bind from TodoAddViewModel
    /// Todo 추가 가능 여부
    let todoCanBeAdd = Observable(false)

    // MARK: - Result
    let todoContent: Observable<TodoContent?> = Observable(nil)
    let isStandby = Observable(false)

    // MARK: - Init
    init() {
        addButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.checkIfTodoCanBeAdd()
        }

        todoCanBeAdd.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                if self.detailTodoList.value.isEmpty {
                    let category = self.category ?? ""
                    self.todoContent.value = (category, [])
                } else {
                    let category = self.category ?? ""
                    let detailTodoStructList = self.detailTodoList.value.map { $0.toDetailTodoStruct }
                    self.todoContent.value = (category, detailTodoStructList)
                }
                self.isStandby.value = true
            } else {
                print("카테고리를 입력해주세요!!")
                self.todoContent.value = nil
                self.isStandby.value = false
            }
        }
    }

}

private extension TodoContentWritingViewModel {
    
    /// Todo를 추가 가능한지 검사하는 메서드
    func checkIfTodoCanBeAdd() {
        // 카테고리가 반드시 있어야 한다.
        guard category != nil else {
            todoCanBeAdd.value = false
            return
        }
        todoCanBeAdd.value = true
    }

}
