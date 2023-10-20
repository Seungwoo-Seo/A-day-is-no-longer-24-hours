//
//  TodoTimeSettingMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import UIKit

final class TodoTimeSettingMainView: BaseView {
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
        let view = LabelTextFieldPickerView(title: "언제 시작할 건가요?")
        view.picker.tag = 0
        return view
    }()
    let howMuchToDoView = {
        let view = LabelTextFieldPickerView(title: "얼마 동안 할 건가요?")
        view.picker.tag = 1
        return view
    }()

    // 여기서 미안하지만 알아서 맞춰줘야해 최대 시간보다 낮은 시간대로


    // 그 분기를 선택했으니까 각 분기의 범위 => 즉, 몇 시간인지 알 수 있으니까
    // 사용자한태 입력을 받으면 현재 분기에서 최대로 적용할 수 있는 시간이 된다
    // 사용자한태 입력을 받으면(숫자를 입력받아야지) 해당 숫자를 분으로 다 바꿔서 더해주면 끝값이 나오니까
    // 시작 값과 끝 값이 적용되는지 확인해 보고


    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        [
            prevButton,
            nextButtom,
            whenIsStartView,
            howMuchToDoView
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
        }

        nextButtom.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview()
        }

        whenIsStartView.snp.makeConstraints { make in
            make.top.equalTo(nextButtom.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        howMuchToDoView.snp.makeConstraints { make in
            make.top.equalTo(whenIsStartView.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }

}
