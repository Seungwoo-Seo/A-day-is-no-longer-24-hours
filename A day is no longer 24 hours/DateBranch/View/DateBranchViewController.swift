//
//  DateBranchViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/08.
//

import FSCalendar
import UIKit

final class DateBranchViewController: BaseViewController {
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let calendarLabel = {
        let label = UILabel()
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.textColor = Constraints.Color.white
        label.text = "날짜를 선택해주세요 🗓"
        return label
    }()
    private lazy var calendarView = {
        let view = FSCalendar(frame: .zero)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constraints.Color.black
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.headerTitleColor = Constraints.Color.white
        view.appearance.headerDateFormat = "yyyy년 M월"
        view.appearance.headerMinimumDissolvedAlpha = 0
        view.appearance.todayColor = Constraints.Color.clear
        view.appearance.titleTodayColor = Constraints.Color.todayColor
        view.appearance.weekdayTextColor = Constraints.Color.white
        view.appearance.titleDefaultColor = Constraints.Color.white

        view.allowsMultipleSelection = true
        view.swipeToChooseGesture.isEnabled = true
        view.register(DIYCalendarCell.self, forCellReuseIdentifier: "DIYCalendarCell")

        return view
    }()

    private let pickerStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 48
        return view
    }()
    private let bedTimeLabelTimePickerView = LabelDatePickerView(title: "언제 잘건가요? 😴")
    private lazy var wakeUpTimeLabelTimePickerView = TimeSettingView(title: "얼마나 잘건가요? 🐔", delegate: self)
    private let dateBranchLabelPickerView = LabelPickerView(title: "하루를 어떻게 나눌건가요? ✂️")



    @objc func valueChanged(_ picker: UIDatePicker) {
        let t = picker.calendar.dateComponents(in: .current, from: picker.date)
        viewModel.bedTimeComponents.value = t

        let hoursToAdd = 7
        let minutesToAdd = 25

        let futureTime = picker.calendar.date(byAdding: .hour, value: hoursToAdd, to: picker.date)!
        let finalTime = picker.calendar.date(byAdding: .minute, value: minutesToAdd, to: futureTime)!

        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "HH mm"
        print(format.string(from: finalTime))
    }

    @objc func valueChanged1(_ picker: UIDatePicker) {
        let t = picker.calendar.dateComponents(in: .current, from: picker.date)
        viewModel.wakeUpTimeComponents.value = t
//        viewModel.wakeUpTimeCalendar.value = picker.calendar
    }


    // MARK: - ViewModel
    let viewModel = DateBranchViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bedTimeLabelTimePickerView.datePicker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
//        wakeUpTimeLabelTimePickerView.datePicker.addTarget(self, action: #selector(valueChanged1), for: .valueChanged)

        // Output
        viewModel.dateList.bind { [weak self] (dateList) in
            guard let self else {return}
            self.viewModel.dateListVaildation(dateList)
        }

        viewModel.dateListIsVaildate.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.calendarView.layer.borderColor = UIColor.green.cgColor
            } else {
                self.calendarView.layer.borderColor = UIColor.darkGray.cgColor
            }
        }

        viewModel.bedTimeComponents.bind { [weak self] _ in
            guard let self else {return}
            self.viewModel.sleepTimeVaildation()
        }

        viewModel.wakeUpTimeComponents.bind { [weak self] _ in
            guard let self else {return}
            self.viewModel.sleepTimeVaildation()
        }
    }

    @objc func didTapApplyBarButtonItem() {
        // TODO: 여기에 DateBranch 레코드를 추가하는 로직을 작성해야함
//        calendarView.selectedDates.forEach {
//            // 이 날짜 중에 렘에 존재하는 날짜가 있는지 검사
//            $0
//        }
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = .black
        let applyBarButtonItem = UIBarButtonItem(title: "적용하기", style: .plain, target: self, action: #selector(didTapApplyBarButtonItem))
        applyBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = applyBarButtonItem
        calendarView.layer.borderColor = UIColor.darkGray.cgColor
        calendarView.layer.borderWidth = 1
        calendarView.layer.cornerRadius = 8

        dateBranchLabelPickerView.isHidden = true

    }

    override func initialHierarchy() {
        super.initialHierarchy()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            calendarLabel,
            calendarView,
            pickerStackView
        ].forEach { contentView.addSubview($0) }

        [
            bedTimeLabelTimePickerView,
            wakeUpTimeLabelTimePickerView,
            dateBranchLabelPickerView
        ].forEach { pickerStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        calendarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        calendarView.snp.makeConstraints { make in
            make.top.equalTo(calendarLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }

        pickerStackView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(48)
        }
    }

}

// MARK: - FSCalendarDataSource
extension DateBranchViewController: FSCalendarDataSource {

    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "DIYCalendarCell", for: date, at: position)
        return cell
    }

    func calendar(
        _ calendar: FSCalendar,
        willDisplay cell: FSCalendarCell,
        for date: Date,
        at position: FSCalendarMonthPosition
    ) {
        self.configure(cell: cell, for: date, at: position)
    }

//    func calendar(
//        _ calendar: FSCalendar,
//        numberOfEventsFor date: Date
//    ) -> Int {
//        return 2
//    }

}

// MARK: - FSCalendarDelegate
extension DateBranchViewController: FSCalendarDelegate {

    func calendar(
        _ calendar: FSCalendar,
        boundingRectWillChange bounds: CGRect,
        animated: Bool
    ) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }

    func calendar(
        _ calendar: FSCalendar,
        didDeselect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        configureVisibleCells()

        viewModel.dateList.value.removeAll {
            $0 == date
        }
    }

    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        // 한국 시간으로 변경 필요
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyyMMdd"
        let tapDate = format.string(from: date) // 년월일 이니까 Unique 하다.
        print("탭한 날은 -> \(tapDate)")
        configureVisibleCells()

        viewModel.dateList.value.append(date)

        // 탭 했을 때 해당 날짜가 분기처리 되었는지 확인하고

        // 만약 분기 처리가 되어 있다면 Tabman을 이용한 분기처리와 TimeLine, addTodoBarButtomItem을 보여주고
        // flotyButton을 숨긴다.

        // 되어 있지 않다면 Tabman, TimeLineView, addTodoBarButtonItem을 숨기고 flotyButton을 보여준다.
    }

}

// MARK: - FSCalendarDelegateAppearance
extension DateBranchViewController: FSCalendarDelegateAppearance {

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        fillSelectionColorFor date: Date
    ) -> UIColor? {
        return calendar.today == date ? Constraints.Color.todayColor : Constraints.Color.white
    }

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        return Constraints.Color.black
    }

}

// MARK: - UIPickerViewDataSource
extension DateBranchViewController: UIPickerViewDataSource {

    // 여기도 유동적으로 들어가야해 왜냐면
    // 분기는 하루 생활시간에서 "시"의 갯수보다 많을 수 없다
    // 즉, 취침시간이 6시간이라고 가정했을 때
    // 생활 시간은 18시간이고
    // 이 하루의 최대 분기는 18개가 최대
    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return viewModel.numberOfComponents
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return 1//viewModel.numberOfRowsInComponent
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return viewModel.titleForRow(row)
    }
}

extension DateBranchViewController: UIPickerViewDelegate {

}

extension DateBranchViewController: TimeSettingViewDelegate {

    func didSelectRow(_ stringValue: String, isHour: Bool) {
        if isHour {
            print("hour -> ", stringValue)
        } else {
            print("minute -> ", stringValue)
        }
    }

}

private extension DateBranchViewController {

    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    private func configure(
        cell: FSCalendarCell,
        for date: Date,
        at position: FSCalendarMonthPosition
    ) {

        let diyCell = (cell as! DIYCalendarCell)
        // Configure selection layer
        if position == .current {

            var selectionType = SelectionType.none

            if calendarView.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendarView.selectedDates.contains(date) {
                    if calendarView.selectedDates.contains(previousDate) && calendarView.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendarView.selectedDates.contains(previousDate) && calendarView.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendarView.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType

        } else {
            diyCell.selectionLayer.isHidden = true
        }
    }

}
