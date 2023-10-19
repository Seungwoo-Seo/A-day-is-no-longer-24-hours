//
//  DayDividedSelectViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import UIKit

final class DayDividedSelectViewController: BaseViewController {
    // MARK: - View
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "Todo를 추가할 Day를 선택해주세요."
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.numberOfLines = 0
        return label
    }()
    lazy var dayDividedPickerView = {
        let view = UIPickerView()
        view.backgroundColor = Constraints.Color.lightGray_alpha012
        view.tintColor = Constraints.Color.white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.dataSource = self
        view.delegate = self
        return view
    }()

    // MARK: - ViewModel
    let viewModel: DayDividedSelectViewModel

    // MARK: - Init
    init(viewModel: DayDividedSelectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.viewModel.divideValue.bind { _ in
            self.dayDividedPickerView.reloadAllComponents()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            descriptionLabel,
            dayDividedPickerView
        ].forEach { view.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        dayDividedPickerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
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
