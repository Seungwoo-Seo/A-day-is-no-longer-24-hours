//
//  StartStandardTodoHeader.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import UIKit

final class StartStandardTodoHeader: BaseCollectionReusableView {
    // MARK: - View
    private let timeLabel = TimeLabel(style: .standard)
    private let circleImageView = CircleImageView(style: .start)
    private let timeLineView = LineView(style: .timeLine)
    private let horizontalView = LineView(style: .separator)
    private let titleLabel = TitleLabel(style: .start)
    private let verticalView = LineView(style: .separator)
    private let stateButton = StateButton()

    // MARK: - Configure
    func configure(_ todoSection: TodoSection) {
        timeLabel.text = todoSection.startTime
        titleLabel.setTitle(
            category: todoSection.category,
            title: todoSection.title
        )
    }

    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        [
            timeLabel,
            circleImageView,
            timeLineView,
            horizontalView,
            titleLabel,
            verticalView,
            stateButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }

        circleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
        }

        timeLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalTo(circleImageView)
            make.verticalEdges.equalToSuperview()
        }

        horizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-4)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLineView.snp.trailing).offset(20)
            make.centerY.equalTo(timeLabel)
        }

        verticalView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }

        stateButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.centerY.equalTo(timeLabel)
        }
    }

}
