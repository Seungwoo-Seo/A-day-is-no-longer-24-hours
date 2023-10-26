//
//  LabelPickerView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/09.
//

import UIKit

final class LabelPickerView: BaseView {
    private let titleLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    let picker = {
        let picker = UIPickerView()
        picker.backgroundColor = Constraints.Color.lightGray_alpha012
        picker.layer.cornerRadius = 8
        picker.clipsToBounds = true
        return picker
    }()
    private let bottomDescriptionLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.darkGray
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.numberOfLines = 0
        return label
    }()

    convenience init(title: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [titleLabel, picker, bottomDescriptionLabel].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 8
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        picker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview()
        }

        bottomDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(picker.snp.bottom).offset(offset)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func setBottomDescriptionLabel(text: String) {
        self.bottomDescriptionLabel.text = text
    }

}
