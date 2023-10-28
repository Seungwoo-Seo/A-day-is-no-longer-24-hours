//
//  ScheduleMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/24.
//

import FSCalendar
import UIKit

protocol ScheduleMainViewDelegate: AnyObject {
    func calendarCurrentPageDidChange(
        scope: FSCalendarScope,
        currentPage: Date
    )
    func calendarDidSelect(_ date: Date)
}

final class ScheduleMainView: BaseView {
    lazy var calendarView = {
        let view = FSCalendar(frame: .zero)
        view.backgroundColor = Constraints.Color.black
        view.delegate = self
        view.scope = .week
        view.headerHeight = 0
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.borderRadius = 8
        view.appearance.titleWeekendColor = Constraints.Color.systemBlue
        view.appearance.selectionColor = Constraints.Color.white
        view.appearance.todayColor = Constraints.Color.clear
        view.appearance.titleTodayColor = Constraints.Color.todayColor
        view.appearance.weekdayTextColor = Constraints.Color.white
        view.appearance.titleDefaultColor = Constraints.Color.white
        view.select(view.today)
        return view
    }()
    let lineView = {
        let view = LineView(style: .separator)
        view.backgroundColor = Constraints.Color.systemBlue.withAlphaComponent(0.5)
        return view
    }()

    // MARK: - Delegate
    weak var delegate: ScheduleMainViewDelegate?

    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        [calendarView, lineView].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}

extension ScheduleMainView: FSCalendarDelegate {

    func calendar(
        _ calendar: FSCalendar,
        boundingRectWillChange bounds: CGRect,
        animated: Bool
    ) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        layoutIfNeeded()
    }

    func calendarCurrentPageDidChange(
        _ calendar: FSCalendar
    ) {
        delegate?.calendarCurrentPageDidChange(
            scope: calendar.scope,
            currentPage: calendar.currentPage
        )
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

        // 해당 날짜에 적용되는 하루 나눈 값과 Todo를 가져와야지?
        // 여기서 탭하면 DayDivideContainer가 알아야하고
        // 즉, DayDivideContainerViewModel에서 바인딩 해줘야하겠네
        delegate?.calendarDidSelect(date)
    }
}

// MARK: - FSCalendarDelegateAppearance
extension ScheduleMainView: FSCalendarDelegateAppearance {

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        fillSelectionColorFor date: Date
    ) -> UIColor? {
        return Constraints.Color.white
    }

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        return Constraints.Color.black
    }

}
