//
//  TodoTimeSettingMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import UIKit

final class TodoTimeSettingMainView: BaseView {
    private let scrollView = {
        let view = UIScrollView(frame: .zero)
        return view
    }()
    private let contentView = {
        let view = UIView()
        return view
    }()
    lazy var prevButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "이전으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    lazy var nextButtom = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "다음으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    let whenIsStartView = {
        let view = LabelPickerView(title: "언제 시작할 건가요?")
        view.picker.tag = 0
        return view
    }()
    let howMuchToDoView = {
        let view = LabelPickerView(title: "얼마 동안 할 건가요?")
        view.picker.tag = 1
        return view
    }()
    let errorLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.textColor = Constraints.Color.red
        return label
    }()

    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        [
            prevButton,
            nextButtom,
            scrollView
        ].forEach { addSubview($0) }

        scrollView.addSubview(contentView)

        [
            whenIsStartView,
            howMuchToDoView,
            errorLabel
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset/4)
            make.leading.equalToSuperview()
        }

        nextButtom.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset/4)
            make.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(nextButtom.snp.bottom).offset(offset/4)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }

        whenIsStartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        howMuchToDoView.snp.makeConstraints { make in
            make.top.equalTo(whenIsStartView.snp.bottom).offset(offset*3)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(howMuchToDoView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(inset*2)
        }
    }

}
