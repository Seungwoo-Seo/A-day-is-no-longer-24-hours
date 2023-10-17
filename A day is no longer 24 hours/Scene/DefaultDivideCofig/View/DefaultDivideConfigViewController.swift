//
//  DefaultDivideConfigViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/13.
//

import UIKit

final class DefaultDivideConfigViewController: BaseViewController {
    // MARK: - View
    private let mainView = DefaultDivideConfigMainView()

    // MARK: - ViewModel
    private let viewModel: DefaultDivideCofigViewModel

    // MARK: - Init
    private init(_ viewModel: DefaultDivideCofigViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModel: DefaultDivideCofigViewModel) {
        self.init(viewModel)

        viewModel.divideValueList.bind() { [weak self] (list) in
            guard let self else {return}
            self.mainView.dateDividePickerView.reloadAllComponents()
            self.mainView.dateDividePickerView.selectRow(0, inComponent: 0, animated: true)
            self.viewModel.currentDivideValue.value = list.first ?? 1
        }

        viewModel.currentDivideValue.bind { [weak self] (value) in
            guard let self else {return}
            self.mainView.divideAndStartButton.configuration?.title = "\(value)일로 나누고 시작하기"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
        mainView.prevButton.addTarget(
            self,
            action: #selector(didTapPrevButton),
            for: .touchUpInside
        )
        mainView.dateDividePickerView.dataSource = self
        mainView.dateDividePickerView.delegate = self
        mainView.divideAndStartButton.addTarget(
            self,
            action: #selector(didTapDivideAndStartButton),
            for: .touchUpInside
        )
    }

    // MARK: - Event
    @objc
    private func didTapPrevButton() {
        viewModel.prevButtonTapped.value.toggle()
    }

    @objc
    private func didTapDivideAndStartButton() {
        viewModel.divideAndStartButtonTapped.value.toggle()
    }
}

// MARK: - UIPickerViewDataSource
extension DefaultDivideConfigViewController: UIPickerViewDataSource {

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

// MARK: - UIPickerViewDelegate
extension DefaultDivideConfigViewController: UIPickerViewDelegate {

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
