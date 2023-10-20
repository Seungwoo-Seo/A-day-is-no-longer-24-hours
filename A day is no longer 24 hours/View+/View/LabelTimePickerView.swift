//
//  LabelTimePickerView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/11.
//

import UIKit

enum LabelTimePickerViewSection: Int, CaseIterable {
    case ampm
    case hour
    case minute

    var stringList: [String] {
        switch self {
        case .ampm: return ["오전", "오후"]
        case .hour: return ["6", "7", "8", "9", "10", "11", "12", "8", "9", "10", "11", "12"]
        case .minute: return ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
        }
    }
}

final class LabelTimePickerView: BaseView {
    private let titleLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    lazy var picker = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.tintColor = Constraints.Color.systemBlue
        picker.backgroundColor = Constraints.Color.lightGray_alpha012
        picker.setValue(Constraints.Color.white, forKeyPath: "textColor")
        picker.layer.borderWidth = 1
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

        [titleLabel, picker].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        picker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    var currentAmpm: String?
    var currentHour: String?
    var currentMinute: String?

}

extension LabelTimePickerView: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return LabelTimePickerViewSection.allCases.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        let section = LabelTimePickerViewSection.allCases[component]
        return section.stringList.count
    }

}

extension LabelTimePickerView: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let section = LabelTimePickerViewSection.allCases[component]
        return section.stringList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let section = LabelTimePickerViewSection.allCases[component]

        switch section {
        case .ampm:
            // 오전 or 오후
            let ampm = section.stringList[row]


        case .hour:
            currentHour = section.stringList[row]
        case .minute:
            currentMinute = section.stringList[row]
        }

    }

}
