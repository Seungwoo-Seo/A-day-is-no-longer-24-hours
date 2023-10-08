//
//  DateBranchViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/08.
//

import FSCalendar
import UIKit
import TextFieldEffects

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}


final class DateBranchViewController: BaseViewController {
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let scrollView = {
        let view = UIScrollView()
        return view
    }()
    private let contentView = {
        let view = UIView()
        return view
    }()
    let calendarLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
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

    let sleepStartTimeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.text = "수면 시간 😴"
        return label
    }()

    let textField1 = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        return view
    }()

    let sleepEndTimeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.text = "기상 시간 🐔"
        return label
    }()

    let textField2 = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        return view
    }()

    let dateBranchLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.text = "하루를 며칠로 나누시겠습니까? 📐"
        return label
    }()

    let textField3 = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        return view
    }()

    private lazy var applyButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .black
        config.background.backgroundColor = .white
        config.title = "적용하기"
        let button = UIButton(configuration: config)
        return button
    }()


    // MARK: - ViewModel
    let viewModel = DateBranchViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.layer.addBorder([.top], color: .white, width: 1)




//        let applyBarButtonItem = UIBarButtonItem(title: "적용하기", style: .plain, target: self, action: #selector(didTapApplyBarButtonItem))
//        navigationItem.title = "test"
//        navigationItem.rightBarButtonItem = applyBarButtonItem
        calendarView.layer.borderColor = UIColor.darkGray.cgColor
        calendarView.layer.borderWidth = 1
        calendarView.layer.cornerRadius = 8

    }

    @objc func didTapApplyBarButtonItem() {
        // TODO: 여기에 DateBranch 레코드를 추가하는 로직을 작성해야함
//        calendarView.selectedDates.forEach {
//            // 이 날짜 중에 렘에 존재하는 날짜가 있는지 검사
//            $0
//        }
    }

    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            calendarLabel,
            calendarView,

            sleepStartTimeLabel,
            textField1,

            sleepEndTimeLabel,
            textField2,

            dateBranchLabel,
            textField3,

            applyButton
        ].forEach { contentView.addSubview($0) }


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

        sleepStartTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        textField1.snp.makeConstraints { make in
            make.top.equalTo(sleepStartTimeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        sleepEndTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        textField2.snp.makeConstraints { make in
            make.top.equalTo(sleepEndTimeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        dateBranchLabel.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        textField3.snp.makeConstraints { make in
            make.top.equalTo(dateBranchLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        applyButton.snp.makeConstraints { make in
            make.top.equalTo(textField3.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
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
