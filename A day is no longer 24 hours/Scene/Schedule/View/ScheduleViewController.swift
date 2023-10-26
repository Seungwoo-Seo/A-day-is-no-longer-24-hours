//
//  ScheduleViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import FSCalendar
import UIKit

final class ScheduleViewController: BaseViewController {
    // MARK: - View
    private let titleLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_bold
        return label
    }() // 여기 있어야하고
    private lazy var titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
    private lazy var addTodoBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddTodoBarButtonItem)
        )
        button.tintColor = Constraints.Color.white
        return button
    }()
    private let mainView = ScheduleMainView()
    lazy var dayDivideView = DayDivideCotainerViewController(
        viewModel: viewModel.dayDivideContainerViewModel
    )

    // MARK: - ViewModel
    let viewModel = ScheduleViewModel()

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // bind
        viewModel.currentMonth.bind { [weak self] (currentMonth) in
            guard let self else {return}
            self.titleLabel.text = currentMonth
        }

        // initial input
        viewModel.updateCurrentPage(date: mainView.calendarView.currentPage)
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        mainView.delegate = self
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.leftBarButtonItem = titleBarButtonItem
        navigationItem.rightBarButtonItem = addTodoBarButtonItem
        addChild(dayDivideView)
        view.addSubview(dayDivideView.view)
        dayDivideView.didMove(toParent: self)
    }

    override func initialLayout() {
        super.initialLayout()

        dayDivideView.view.snp.makeConstraints { make in
            make.top.equalTo(mainView.calendarView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Event
    @objc
    private func didTapAddTodoBarButtonItem(_ sender: UIBarButtonItem) {
        presentTodoAddContainerViewController()
    }

}

extension ScheduleViewController: ScheduleMainViewDelegate {

    func calendarCurrentPageDidChange(
        scope: FSCalendarScope,
        currentPage: Date
    ) {
        switch scope {
        case .month:
            viewModel.updateCurrentPage(
                date: currentPage,
                isMonth: true
            )
        case .week:
            viewModel.updateCurrentPage(
                date: currentPage
            )
        @unknown default:
            fatalError("calendar scope case 추가됌")
        }
    }

    func calendarDidSelect(_ date: Date) {
        viewModel.selectedYmd.value = date.toString
    }

}

// MARK: - Action
private extension ScheduleViewController {

    func goToToday() {
//        calendarView.select(calendarView.today)
//        viewModel.calendarViewSelected.value.toggle()
    }

    // MARK: - 여기선 걍 선택한 날짜만 넘기면 될꺼 같은데
    func presentTodoAddContainerViewController() {
        let selectedYmd = viewModel.selectedYmd.value
        let viewModel = TodoAddViewModel(selectedYmd: Observable(selectedYmd))
        let vc = TodoAddContainerViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
