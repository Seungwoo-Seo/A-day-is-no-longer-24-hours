//
//  DayDividedSelectViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import UIKit

final class DayDividedSelectViewController: BaseViewController {
    // MARK: - View
    let mainView = DayDividedSelectMainView()

    // MARK: - ViewModel
    let viewModel: DayDividedSelectViewModel

    // MARK: - Init
    init(viewModel: DayDividedSelectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    private func bind() {
        viewModel.dividedValue.bind { [weak self] (dividedValue) in
            guard let self else {return}
            self.mainView.dayDividedPickerView.reloadAllComponents()
        }
    }

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
        mainView.dayDividedPickerView.dataSource = self
        mainView.dayDividedPickerView.delegate = self
        mainView.prevButton.addTarget(
            self,
            action: #selector(didTapPrevButton),
            for: .touchUpInside
        )
        mainView.nextButtom.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
    }

    // MARK: - Event
    @objc
    func didTapPrevButton(_ sender: UIButton) {
        viewModel.prevButtonTapped.value.toggle()
    }

    @objc
    func didTapNextButton(_ sender: UIButton) {
        viewModel.nextButtonTapped.value.toggle()
    }

}

extension DayDividedSelectViewController: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return viewModel.numberOfComponents
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return viewModel.numberOfRowsInComponent
    }

}

extension DayDividedSelectViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int
    ) -> NSAttributedString? {
        return viewModel.attributedTitleForRow(row)
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        viewModel.didSelectRow(row)
    }

}
