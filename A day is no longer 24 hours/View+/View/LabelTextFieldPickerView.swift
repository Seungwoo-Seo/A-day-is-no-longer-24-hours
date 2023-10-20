//
//  LabelTextFieldPickerView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/09.
//

import UIKit

final class LabelTextFieldPickerView: BaseView {
    private let titleLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    let picker = {
        let picker = UIPickerView()
        picker.tintColor = Constraints.Color.systemBlue
        picker.backgroundColor = Constraints.Color.white
        return picker
    }()
    lazy var textField = {
        let textField = UITextField()
        textField.tintColor = Constraints.Color.white
        textField.textColor = Constraints.Color.white
        textField.backgroundColor = Constraints.Color.lightGray_alpha012
        textField.inputView = picker
        return textField
    }()

    convenience init(title: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [titleLabel, textField].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }

}
