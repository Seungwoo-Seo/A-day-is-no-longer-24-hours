//
//  TodoTimeSettingViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import UIKit

// 살짝 아쉽긴 한데 일단 유저가 알맞게 선택해주길
final class TodoTimeSettingViewController: BaseViewController {
    // MARK: - View
    let mainView = TodoTimeSettingMainView()

    // 필연적으로 분은 0부터 59까지 표현을 해줘야하기 때문에
    // 실제 해당 분기에 사용하는 시간보다 큰 값이 나올 수 있다.
    // 그 부분도 조건문처리 해줘야한다.


    // MARK: - ViewModel
    let viewModel: TodoTimeSettingViewModel

    // MARK: - Inif
    init(viewModel: TodoTimeSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.dividedDay.bind { [weak self] (dividedDay) in
            guard let self, let _ = dividedDay else {return}
            self.mainView.whenIsStartView.picker.reloadAllComponents()
            self.mainView.howMuchToDoView.picker.reloadAllComponents()
        }
    }

    func validation() {
        // 360과 720 사이에 들어오고
        // db에 검색해봤을 때
        // 사용가능한 시간이면 통과~
    }

    override func loadView() {
        view = mainView
    }


    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
        mainView.whenIsStartView.picker.dataSource = self
        mainView.howMuchToDoView.picker.dataSource = self
        mainView.whenIsStartView.picker.delegate = self
        mainView.howMuchToDoView.picker.delegate = self
    }

    @objc
    func valueChangedwhenIsStartViewPickerView(_ sender: UIDatePicker) {
        let components = sender.calendar.dateComponents(
            in: TimeZone(abbreviation: "UTC")!,
            from: sender.date
        )
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let hourToMinute = hour * 60 + minute

        if hourToMinute >= 360 {

        }
    }

}

extension TodoTimeSettingViewController: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return viewModel.numberOfComponents
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return viewModel.numberOfRowsInComponent(
            component,
            tag: pickerView.tag
        )
    }

}

extension TodoTimeSettingViewController: UIPickerViewDelegate {

//    func pickerView(
//        _ pickerView: UIPickerView,
//        titleForRow row: Int,
//        forComponent component: Int
//    ) -> String? {
//        <#code#>
//    }

    func pickerView(
        _ pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int
    ) -> NSAttributedString? {
        return viewModel.attributedTitleForRow(
            row,
            forComponent: component,
            tag: pickerView.tag
        )
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        
    }

}
