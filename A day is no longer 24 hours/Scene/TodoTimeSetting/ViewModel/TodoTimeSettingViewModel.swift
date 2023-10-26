//
//  TodoTimeSettingViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import Foundation

typealias Time = (hour: Int, minute: Int)
typealias TodoTimeRange = (whenIsStartTime: Int, whenIsEndTime: Int)

final class TodoTimeSettingViewModel {
    // MARK: - bind from self
    let selectedDividedDay: Observable<DividedDay?> = Observable(nil)
    let whenIsTodoStartTime: Observable<Time?> = Observable(nil)
    let howMuchTodoTime: Observable<Time?> = Observable(nil)

    // MARK: - bind from TodoTimeSettingViewController
    let whenIsUseHourMinuteList: Observable<[(hour: Int, minuteList: [Int])]> = Observable([])
    var currentUseHourRow = 0

    let livingHourMinuteList: Observable<[(hour: Int, minuteList: [Int])]> = Observable([])
    var currentLivingHourRow = 0

    let whenIsStartViewBottomDescriptionText = Observable("")
    let howMuchTodoViewBottomDescriptionText = Observable("")

    // 사용할 수 있는 시간인지
    let timeOverFlow = Observable(true)
    let timeAvailable = Observable(false)

    // MARK: - bind from TodoAddContainerViewController
    let prevButtonTapped = Observable(false)
    let nextButtonTapped = Observable(false)

    // MARK: - Result, bind from TodoAddViewModel
    // 사용하고 싶은 시간 범위
    let wantTimeRange: Observable<TodoTimeRange?> = Observable(nil)

    // MARK: - Init
    init() {
        selectedDividedDay.bind { [weak self] (selectedDividedDay) in
            guard let self, let selectedDividedDay else {return}
            self.updateValues(by: selectedDividedDay)
        }

        whenIsTodoStartTime.bind { [weak self] (whenIsStartTime) in
            guard let self, let _ = whenIsStartTime else {return}
            self.updateWantTimeRange()
        }

        howMuchTodoTime.bind { [weak self] (howLongTodoRunTime) in
            guard let self, let _ = howLongTodoRunTime else {return}
            self.updateWantTimeRange()
        }
    }

}

// MARK: - UIPickerViewDataSource
extension TodoTimeSettingViewModel {

    enum TodoTimeSettingPickerViewKind: Int, CaseIterable {
        case whenIsStartTime
        case howMuchTime
    }

    enum TodoTimeSettingPickerViewComponentKind: Int, CaseIterable {
        case hour
        case minute
    }

    var numberOfComponents: Int {
        return TodoTimeSettingPickerViewComponentKind.allCases.count
    }

    func numberOfRowsInComponent(
        _ component: Int,
        tag: Int
    ) -> Int {
        let pickerView = TodoTimeSettingPickerViewKind.allCases[tag]
        let component = TodoTimeSettingPickerViewComponentKind.allCases[component]

        switch pickerView {
        case .whenIsStartTime:
            switch component {
            case .hour:
                return whenIsUseHourMinuteList.value.count
            case .minute:
                return whenIsUseHourMinuteList.value[currentUseHourRow].minuteList.count
            }

        case .howMuchTime:
            switch component {
            case .hour:
                return livingHourMinuteList.value.count
            case .minute:
                return livingHourMinuteList.value[currentLivingHourRow].minuteList.count
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
extension TodoTimeSettingViewModel {

        func attributedTitleForRow(
            _ row: Int,
            forComponent component: Int,
            tag: Int
        ) -> NSAttributedString {
        let pickerView = TodoTimeSettingPickerViewKind.allCases[tag]
        let component = TodoTimeSettingPickerViewComponentKind.allCases[component]

        switch pickerView {
        case .whenIsStartTime:
            switch component {
            case .hour:
                return NSAttributedString(
                    string: "\(whenIsUseHourMinuteList.value[row].hour) 시",
                    attributes: [.foregroundColor: Constraints.Color.white]
                )
            case .minute:
                return NSAttributedString(
                    string: "\(whenIsUseHourMinuteList.value[currentUseHourRow].minuteList[row]) 분",
                    attributes: [.foregroundColor: Constraints.Color.white]
                )
            }

        case .howMuchTime:
            switch component {
            case .hour:
                return NSAttributedString(
                    string: "\(livingHourMinuteList.value[row].hour) 시간",
                    attributes: [.foregroundColor: Constraints.Color.white]
                )
            case .minute:
                return NSAttributedString(
                    string: "\(livingHourMinuteList.value[currentLivingHourRow].minuteList[row]) 분",
                    attributes: [.foregroundColor: Constraints.Color.white]
                )
            }
        }
    }

    func didSelectRow(
        _ row: Int,
        inComponent component: Int,
        tag: Int,
        completion: () -> Int
    ) {
        let pickerView = TodoTimeSettingPickerViewKind.allCases[tag]
        let component = TodoTimeSettingPickerViewComponentKind.allCases[component]

        switch pickerView {
        case .whenIsStartTime:
            switch component {
            case .hour:
                currentUseHourRow = row
                whenIsTodoStartTime.value?.hour = whenIsUseHourMinuteList.value[row].hour
                let minuteIndex = completion()
                whenIsTodoStartTime.value?.minute = whenIsUseHourMinuteList.value[row].minuteList[minuteIndex]

            case .minute:
                whenIsTodoStartTime.value?.minute = whenIsUseHourMinuteList.value[currentUseHourRow].minuteList[row]
            }

        case .howMuchTime:
            switch component {
            case .hour:
                currentLivingHourRow = row
                howMuchTodoTime.value?.hour = livingHourMinuteList.value[row].hour
                let minuteIndex = completion()
                print(minuteIndex)
                howMuchTodoTime.value?.minute = livingHourMinuteList.value[row].minuteList[minuteIndex]

            case .minute:
                howMuchTodoTime.value?.minute = livingHourMinuteList.value[currentLivingHourRow].minuteList[row]
            }
        }
    }

}

// MARK: - 비즈니스
private extension TodoTimeSettingViewModel {

    /// selectedDividedDay가 변하면 TodoTimeSetting Scene에서 사용할 데이터들을 update 해주는 메소드
    func updateValues(by selectedDividedDay: DividedDay) {
        whenIsUseHourMinuteList.value = selectedDividedDay.whenIsUseHourMinuteList()
        livingHourMinuteList.value = selectedDividedDay.livingHourMinuteList()

        whenIsTodoStartTime.value = selectedDividedDay.whenIsTodoStartTimeFirstValue
        howMuchTodoTime.value = selectedDividedDay.howMuchTodoTimeFirstValue

        whenIsStartViewBottomDescriptionText.value = "\(selectedDividedDay.startTimeToString)부터 \(selectedDividedDay.endTimeToString) 미만의 시간을 선택해 주세요."
        howMuchTodoViewBottomDescriptionText.value = "최소 1분부터 \(selectedDividedDay.livingTimeToString) 이하로 선택해 주세요."
    }

    func updateWantTimeRange() {
        // 유저가 선택한 시작 시각과 하려는 시간을 가져와서
        guard let whenIsTodoStartTime = whenIsTodoStartTime.value else {return}
        guard let howMuchTodoTime = howMuchTodoTime.value else {return}

        // 분으로 전부 바꾸고 시작 시각의 분 값과 종료 시각의 분 값을 구한다.
        let whenIsTodoStartTimeToMinute = whenIsTodoStartTime.hour * 60 + whenIsTodoStartTime.minute
        let howMuchTodoTimeToMinute = howMuchTodoTime.hour * 60 + howMuchTodoTime.minute
        let whenIsTodEndTimeToMinute = whenIsTodoStartTimeToMinute + howMuchTodoTimeToMinute

        // wantTimeRange 값을 업데이트
        wantTimeRange.value = (whenIsTodoStartTimeToMinute, whenIsTodEndTimeToMinute)
    }

}
