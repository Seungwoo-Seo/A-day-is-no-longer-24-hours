//
//  TodoAddViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import RealmSwift
import UIKit

final class TodoAddViewModel {
    // MARK: - Sub ViewModel
    let dayDividedSelectViewModel = DayDividedSelectViewModel()
    let todoTimeSettingViewModel = TodoTimeSettingViewModel()
    let todoContentWritingViewModel = TodoContentWritingViewModel()

    // MARK: - 유저가 고른 값
    let selectedYmd: Observable<String>
    let selectedDividedValue: Observable<Int?> = Observable(nil)
    let wantTimeRange: Observable<TodoTimeRange?> = Observable(nil)
    let todoContent: Observable<TodoContent?> = Observable(nil)

    // MARK: - bind from TodoAddContainerViewController
    let isDone = Observable(false)

    // MARK: - Just Scene
    lazy var viewControllers = Observable(
        [
            DayDividedSelectViewController(viewModel: dayDividedSelectViewModel),
            TodoTimeSettingViewController(viewModel: todoTimeSettingViewModel),
            TodoContentWritingViewController(viewModel: todoContentWritingViewModel)
        ]
    )

    // MARK: - Realm
    let realm = try! Realm()
    let task = RealmRepository()

    // MARK: - Init
    init(selectedYmd: Observable<String>) {
        self.selectedYmd = selectedYmd
        bind()
        fromDayDividedSelectViewModelBind()
        fromTodoTimeSettingViewModelBind()
        fromTodoContentWritingViewModlBind()
    }

    /// DayDividedSelectViewModel에 바인딩
    private func fromDayDividedSelectViewModelBind() {
        // 3. 유저가 어떤 나눠진 하루를 선택했다면 해당 나눠진 하루의 값(인덱스)을 상위 뷰모델 selectedDividedValue에 전달
        dayDividedSelectViewModel.selectedDiviedDay.bind { [weak self] (selectedDiviedDay) in
            guard let self else {return}
            self.selectedDividedValue.value = selectedDiviedDay
        }
    }

    private func fromTodoTimeSettingViewModelBind() {
        // 6. 원하는 시간 범위가 잡히면
        todoTimeSettingViewModel.wantTimeRange.bind { [weak self] (todoTimeRange) in
            guard let self, let todoTimeRange else {return}
            // 7. 해당 시간 범위를 사용 가능한지 검사
            self.checkWantTimeRange(todoTimeRange)
        }
    }

    private func fromTodoContentWritingViewModlBind() {
        // 8.
        todoContentWritingViewModel.todoContent.bind { [weak self] (todoContent) in
            guard let self, let todoContent else {return}
            // 9.
            self.todoContent.value = todoContent
        }

        // 10.
        todoContentWritingViewModel.isStandby.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                let todo = self.makeTodo()
                self.appendTodo(todo)
                self.isDone.value = true
                print("success")
            } else {
                print("카테고리를 입력해주세요!!")
                self.isDone.value = false
            }
        }
    }

    private func appendTodo(_ todo: Todo) {
        switch task.state(of: selectedYmd.value) {
//        case .onlyDivided(_):
//            print("여기도 일단 넘어간다")

        case .stableAdded(let useDay):
            let selectedDividedValue = selectedDividedValue.value!
            // 여기는 업데이트 해주는게 맞지 왜냐면 이미 UseDay 레코드가 존재하고,
            // todo도 하나 이상 존재하기 때문에
            // 해당 레코드에 적절한 dividedDay의 todoList에 업데이트 해줘야 한다.
            try! realm.write {
                useDay.dividedDayList[selectedDividedValue].todoList.append(todo)

                NotificationCenter.default.post(
                    name: NSNotification.Name.todoListAppend,
                    object: nil
                )
            }

        case .noting(let defaultDayConfiguration):
            let selectedDividedValue = selectedDividedValue.value!

            do {
                try realm.write {
                    let dividedDayList: [DividedDay] = defaultDayConfiguration
                        .dividedDayList.map {
                            DividedDay(
                                day: $0.day,
                                whenIsStartTime: $0.whenIsStartTime,
                                whenIsEndTime: $0.whenIsEndTime,
                                howMuchLivingTime: $0.howMuchLivingTime
                            )
                        }
                    let useDay = UseDay(
                        ymd: selectedYmd.value,
                        whenIsBedTime: defaultDayConfiguration.whenIsBedTime,
                        whenIsWakeUpTime: defaultDayConfiguration.whenIsWakeUpTime,
                        howMuchLifeTime: defaultDayConfiguration.howMuchLivingTime,
                        dividedValue: defaultDayConfiguration.dividedValue,
                        dividedDayList: dividedDayList
                    )
                    useDay.dividedDayList[selectedDividedValue].todoList.append(todo)
                    realm.add(useDay)
                }
                NotificationCenter.default.post(
                    name: NSNotification.Name.todoListAppend,
                    object: nil
                )
            } catch {
                print("너냐?")
            }

        case .never:
            fatalError("넌 사고")
        }
    }

    /// 모두 성공했을 때!
    private func makeTodo() -> Todo {
        let wantTimeRange = wantTimeRange.value!
        let todoContent = todoContent.value!

        // detailTodo가 있는지 없는지에 따라
        if todoContent.detailTodoStructList.isEmpty {
            return Todo(
                kind: .simple,
                whenIsStartTime: wantTimeRange.whenIsStartTime,
                whenIsEndTime: wantTimeRange.whenIsEndTime,
                category: todoContent.category,
                subTitle: nil
            )
        } else {
            let detailTodoList = todoContent.detailTodoStructList.map { $0.toDetailTodo }
            return Todo(
                kind: .detail,
                whenIsStartTime: wantTimeRange.whenIsStartTime,
                whenIsEndTime: wantTimeRange.whenIsEndTime,
                category: todoContent.category,
                subTitle: nil,
                detailTodoList: detailTodoList
            )
        }
    }


    private func bind() {
        // 1. 선택한 날짜가 전달되면
        selectedYmd.bind { [weak self] (ymd) in
            guard let self else {return}

            // 2. DayDividedSelectViewModel에 선택한 날짜가 며칠로 나눴졌는지에 해당하는 데이터를 전달한다.
            self.relayDividedValueToDayDividedSelectViewModel(ymd)
        }

        // 4. selectedDividedValue이 변하면
        selectedDividedValue.bind { [weak self] (selectedDividedValue) in
            guard let self, let selectedDividedValue else {return}

            // 5. TodoTimeSettingViewModel에 선택한 나눠진 하루의 데이터를 전달하기.
            self.relayDividedDayToTodoTimeSettingViewModel(
                self.selectedYmd.value,
                selectedDividedDay: selectedDividedValue
            )
        }
    }

}

// MARK: - PageboyViewControllerDataSource
extension TodoAddViewModel {

    var numberOfViewControllers: Int {
        return viewControllers.value.count
    }

    func viewControllerCorresponding(
        to index: Int
    ) -> UIViewController {
        return viewControllers.value[index]
    }
}

// MARK: - 비즈니스: DayDividedSelectViewModel과 관련된
private extension TodoAddViewModel {

    /// 하루를 며칠로 나눴는지에 해당하는 데이터를 전달해주는 메소드
    func relayDividedValueToDayDividedSelectViewModel(_ ymd: String) {
        switch task.state(of: ymd) {
//        case .onlyDivided(_):
//            print("여기도 일단 넘어간다")

        case .stableAdded(let useDay):
            print("너가 왜 안나와?")
            dayDividedSelectViewModel.dividedValue.value = useDay.dividedValue

        case .noting(let defaultDayConfiguration):
            dayDividedSelectViewModel.dividedValue.value = defaultDayConfiguration.dividedValue

        case .never:
            fatalError("넌 사고")
        }
    }

}

// MARK: - 비즈니스: TodoTimeSettingViewModel과 관련된
private extension TodoAddViewModel {

    /// 선택된 나눠진 하루에 데이터를 전달해주는 메소드
    func relayDividedDayToTodoTimeSettingViewModel(_ ymd: String, selectedDividedDay: Int) {
        switch task.state(of: ymd) {
//        case .onlyDivided(_):
//            print("여기도 일단 넘어간다")

        case .stableAdded(let useDay):
            todoTimeSettingViewModel.selectedDividedDay.value = useDay.dividedDayList[selectedDividedDay]

        case .noting(let defaultDayConfiguration):
            todoTimeSettingViewModel.selectedDividedDay.value = defaultDayConfiguration.dividedDayList[selectedDividedDay]

        case .never:
            fatalError("넌 사고")
        }
    }

    /// 해당 시간 범위를 사용할 수 있는지 검사하는 메서드
    func checkWantTimeRange(_ wantTimeRange: TodoTimeRange) {
        switch task.state(of: selectedYmd.value) {
//        case .onlyDivided(_):
//            print("여기도 일단 넘어가는데 검증 필요없을 걸?")

        case .stableAdded(let useDay):
            let selectedDividedValue = selectedDividedValue.value!
            let dividedDay = useDay.dividedDayList[selectedDividedValue]
            let todoList = dividedDay.todoList

            // 1. 원하는 시간이 하루를 넘어가진 않는지 검사하는 로직
            print("wantTimeRange.whenIsEndTime ==> ", wantTimeRange.whenIsEndTime)
            print("dividedDay.whenIsEndTime ==> ", dividedDay.whenIsEndTime)
            if wantTimeRange.whenIsEndTime > dividedDay.whenIsEndTime {
                self.wantTimeRange.value = nil
                todoTimeSettingViewModel.timeOverFlow.value = false
                return
            }

            // 2. 원하는 시간 범위를 사용할 수 있는지 검사하는 로직
            let timeAvailable = todoList
                .filter {
                    wantTimeRange.whenIsEndTime > $0.whenIsStartTime
                }
                .filter {
                    $0.whenIsEndTime > wantTimeRange.whenIsStartTime
                }
                .isEmpty

            if timeAvailable {
                self.wantTimeRange.value = wantTimeRange
            } else {
                self.wantTimeRange.value = nil
            }
            todoTimeSettingViewModel.timeAvailable.value = timeAvailable

        case .noting(let defaultDayConfiguration):
            let selectedDividedValue = selectedDividedValue.value!
            let dividedDay = defaultDayConfiguration.dividedDayList[selectedDividedValue]
            // 여긴 시간 사용여부 검증말고 시간 범위 오버플로 검증 필요
            // 1. 원하는 시간이 하루를 넘어가진 않는지 검사하는 로직
            print("wantTimeRange.whenIsEndTime ==> ", wantTimeRange.whenIsEndTime)
            print("dividedDay.whenIsEndTime ==> ", dividedDay.whenIsEndTime)
            if wantTimeRange.whenIsEndTime > dividedDay.whenIsEndTime {
                self.wantTimeRange.value = nil
                todoTimeSettingViewModel.timeOverFlow.value = false
                return
            }

            self.wantTimeRange.value = wantTimeRange
            // 2. 미리 설정된 Todo가 없기 때문에 바로 true
            todoTimeSettingViewModel.timeAvailable.value = true
        case .never:
            fatalError("넌 사고")
        }
    }

}
