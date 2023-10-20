//
//  ScheduleViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import FSCalendar
import RealmSwift
import UIKit

final class ScheduleViewController: BaseViewController {
    // MARK: - View
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }() // 여기 있어야하고
    private lazy var titleBarButtonItem = UIBarButtonItem(customView: titleLabel) // 여기 있어야 하고
    private lazy var addTodoBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddTodoBarButtonItem)
        )
        button.tintColor = Constraints.Color.white
        return button
    }() // 여기 있어야 하고
    private lazy var calendarView = {
        let view = FSCalendar(frame: .zero)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constraints.Color.black
        view.scope = .week
        view.headerHeight = 0
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.borderRadius = 8
        view.appearance.titleWeekendColor = .red
        view.appearance.selectionColor = Constraints.Color.white
        view.appearance.todayColor = Constraints.Color.clear
        view.appearance.titleTodayColor = Constraints.Color.todayColor
        view.appearance.weekdayTextColor = Constraints.Color.white
        view.appearance.titleDefaultColor = Constraints.Color.white
        view.select(view.today)
        return view
    }() // mainView로 가도 됌
    lazy var dayDivideView = DayDivideCotainerViewController(
        viewModel: viewModel.dayDivideContainerViewModel
    )

    // MARK: - ViewModel
    let viewModel = ScheduleViewModel()


    let realm = try! Realm()


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // bind
        viewModel.currentMonth.bind { [weak self] (currentMonth) in
            guard let self else {return}
            self.titleLabel.text = currentMonth
        }

        // initial input
        viewModel.currentMonth.value = viewModel.currentPage(date: calendarView.currentPage)
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.leftBarButtonItem = titleBarButtonItem
        navigationItem.rightBarButtonItem = addTodoBarButtonItem
        view.addSubview(calendarView)
        addChild(dayDivideView)
        view.addSubview(dayDivideView.view)
        dayDivideView.didMove(toParent: self)
    }

    override func initialLayout() {
        super.initialLayout()

        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }

        dayDivideView.view.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Event
    @objc
    private func didTapAddTodoBarButtonItem(_ sender: UIBarButtonItem) {
        presentActionSheet()
    }

}

// MARK: - FSCalendarDataSource
extension ScheduleViewController: FSCalendarDataSource {

}

// MARK: - FSCalendarDelegate
extension ScheduleViewController: FSCalendarDelegate {

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

    func calendarCurrentPageDidChange(
        _ calendar: FSCalendar
    ) {
        switch calendar.scope {
        case .month:
            viewModel.currentMonth.value = viewModel.currentPage(
                date: calendarView.currentPage,
                isMonth: true
            )
        case .week:
            viewModel.currentMonth.value = viewModel.currentPage(
                date: calendarView.currentPage
            )
        @unknown default:
            fatalError("calendar scope case 추가됌")
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

        // 해당 날짜에 적용되는 하루 나눈 값과 Todo를 가져와야지?
        // 여기서 탭하면 DayDivideContainer가 알아야하고
        // 즉, DayDivideContainerViewModel에서 바인딩 해줘야하겠네
        viewModel.dayDivideContainerViewModel.didSelectDate.value = date
    }

}

// MARK: - FSCalendarDelegateAppearance
extension ScheduleViewController: FSCalendarDelegateAppearance {

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

// MARK: - Action
private extension ScheduleViewController {

    func goToToday() {
        calendarView.select(calendarView.today)
    }

    func presentActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let simple = UIAlertAction(title: "간단한 Todo", style: .default) { [weak self] _ in
            guard let self else {return}
            self.pushToTodoAddContainerViewController()
        }
        let detail = UIAlertAction(title: "자세한 Todo", style: .default)
        [cancel, simple, detail].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    // MARK: - 여기선 걍 선택한 날짜만 넘기면 될꺼 같은데
    func pushToTodoAddContainerViewController() {
        guard let selectedDate = calendarView.selectedDate else {print("calendarView selectedDate 없음"); return}

        let viewModel = TodoAddViewModel(
            selectedDate: Observable(selectedDate)
        )
        let vc = TodoAddContainerViewController(
            viewModel: viewModel
        )
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
