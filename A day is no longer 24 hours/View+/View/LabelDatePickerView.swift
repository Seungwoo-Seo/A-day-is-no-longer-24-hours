//
//  LabelDatePickerView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/09.
//

import UIKit

final class LabelDatePickerView: BaseView {
    private let titleLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    lazy var datePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.minuteInterval = 5
        picker.tintColor = Constraints.Color.systemBlue
        picker.backgroundColor = Constraints.Color.lightGray_alpha012
        picker.setValue(Constraints.Color.white, forKeyPath: "textColor")
        picker.layer.cornerRadius = 8
        picker.clipsToBounds = true
        return picker
    }()

    convenience init(title: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [titleLabel, datePicker].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

}
