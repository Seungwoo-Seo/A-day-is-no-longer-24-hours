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
    let detailTodoList: CustomObservable<[DetailTodo]> = CustomObservable([])
    // 카테고리 존재 여부 판단
    let categoryExists = CustomObservable(false)

    // MARK: - bind from TodoAddContainerViewController
    let prevButtonTapped = CustomObservable(false)
    let addButtonTapped = CustomObservable(false)

    // MARK: - bind from TodoAddViewModel
    /// Todo 추가 가능 여부
    let todoCanBeAdd = CustomObservable(false)

    // MARK: - Result
    let todoContent: CustomObservable<TodoContent?> = CustomObservable(nil)
    let isStandby = CustomObservable(false)

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
                    let detailTodoStructList = self.detailTodoList.value
                        .filter { !($0.text.trimmingCharacters(in: .whitespaces).isEmpty) }
                        .map { $0.toDetailTodoStruct }
                    self.todoContent.value = (category, detailTodoStructList)
                }
                self.isStandby.value = true
            } else {
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
            categoryExists.value = false
            todoCanBeAdd.value = false
            return
        }
        categoryExists.value = true
        todoCanBeAdd.value = true
    }

}
