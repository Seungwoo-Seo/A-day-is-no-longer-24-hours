//
//  TimeSettingView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/11.
//

import UIKit

protocol TimeSettingViewDelegate: AnyObject {
    /// isHour이 true이면 "시"에 대한 stringValue를 전달하고, isHour이 false이면 "분"에 대한 stringValue를 전달
    func didSelectRow(_ stringValue: String, isHour: Bool)
}

final class TimeSettingView: BaseView {
    // MARK: - View
    let titleLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    let containerStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 16
        return view
    }()

    lazy var hourPicker = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.tag = 0
        return picker
    }()
    let hourStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    lazy var hourTextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .right
        textField.backgroundColor = Constraints.Color.lightGray_alpha012
        textField.tintColor = Constraints.Color.white
        textField.textColor = Constraints.Color.white
        textField.borderStyle = .roundedRect
        textField.inputView = hourPicker
        return textField
    }()
    let hourLabel = {
        let label = UILabel()
        label.text = "시"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()

    lazy var minutePicker = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.tag = 1
        return picker
    }()
    let minuteStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    lazy var minuteTextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .right
        textField.backgroundColor = Constraints.Color.lightGray_alpha012
        textField.tintColor = Constraints.Color.white
        textField.textColor = Constraints.Color.white
        textField.borderStyle = .roundedRect
        textField.inputView = minutePicker
        return textField
    }()
    let minuteLabel = {
        let label = UILabel()
        label.text = "분"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    /// 시작 시간 리스트
    let startHourList = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    /// 시작 시간에서 더해줄 시간 리스트
    let addHourList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let minuteList = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]

    weak var delegate: TimeSettingViewDelegate?

    convenience init(title: String, delegate: TimeSettingViewDelegate?) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.delegate = delegate
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            titleLabel,
            containerStackView
        ].forEach { addSubview($0) }

        [
            hourStackView,
            minuteStackView
        ].forEach { containerStackView.addArrangedSubview($0) }

        [
            hourTextField,
            hourLabel
        ].forEach { hourStackView.addArrangedSubview($0) }

        [
            minuteTextField,
            minuteLabel
        ].forEach { minuteStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

}

extension TimeSettingView: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return 1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        if pickerView.tag == 0 {
            return addHourList.count
        } else {
            return minuteList.count
        }
    }

}

extension TimeSettingView: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        if pickerView.tag == 0 {
            return addHourList[row]
        } else {
            return minuteList[row]
        }
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        if pickerView.tag == 0 {
            let stringValue = addHourList[row]
            hourTextField.text = stringValue
            delegate?.didSelectRow(stringValue, isHour: true)
        } else {
            let stringValue = minuteList[row]
            minuteTextField.text = stringValue
            delegate?.didSelectRow(stringValue, isHour: false)
        }
    }

}

extension TimeSettingView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // 만약 복사 붙여넣기해서 이상한 값을 넣을 수 도 있잖아
        // 여기서 막아버리는 거지
        return true
    }

}
