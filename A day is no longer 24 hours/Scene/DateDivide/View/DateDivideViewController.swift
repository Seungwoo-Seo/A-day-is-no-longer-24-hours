//
//  DateDivideViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/13.
//

import TextFieldEffects
import UIKit

final class DateDivideViewController: BaseViewController {
    // MARK: - View
    let descriptionLabel = {
        let label = UILabel()
        label.text = "하루는 더이상 24시간이 아닙니다.\n하루를 나눠서 n배 효율적인 삶을 살아보세요."
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.numberOfLines = 0
        return label
    }()
    lazy var dateDividePickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constraints.Color.lightGray_alpha012
        view.tintColor = Constraints.Color.white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    let dateDivideSelectButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = Constraints.Color.black
        config.background.backgroundColor = Constraints.Color.white
        config.title = "n일로 나누기"
        let button = UIButton(configuration: config)
        return button
    }()

    let testDataList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            dateDividePickerView,
            descriptionLabel,
            dateDivideSelectButton
        ].forEach { view.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        dateDividePickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(dateDividePickerView.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview().inset(8)
        }

        dateDivideSelectButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

}

// MARK: - UIPickerViewDataSource
extension DateDivideViewController: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return testDataList.count
    }

}

// MARK: - UIPickerViewDelegate
extension DateDivideViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int
    ) -> NSAttributedString? {
        return NSAttributedString(
            string: "\(testDataList[row])",
            attributes: [.foregroundColor: Constraints.Color.white]
        )
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        dateDivideSelectButton.configuration?.title = "\(testDataList[row])일로 나누기"
    }

}
