//
//  EndStandardTodoHeader.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import UIKit

final class EndStandardTodoHeader: BaseCollectionReusableView {
    // MARK: - View
    private let timeLabel = TimeLabel(style: .standard)
    private let circleImageView = CircleImageView(style: .eyewash)
    private let timeLineView = LineView(style: .timeLine)
    private let horizontalView = LineView(style: .separator)
    private let titleLabel = TitleLabel(style: .start)
    private let verticalView = LineView(style: .separator)

    // MARK: - Configure
    func configure(_ todoSection: TodoSection) {
        timeLabel.text = todoSection.endTime
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
            verticalView
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
//            make.width.equalTo(16)
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(horizontalView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(timeLabel)
        }
    }

}

