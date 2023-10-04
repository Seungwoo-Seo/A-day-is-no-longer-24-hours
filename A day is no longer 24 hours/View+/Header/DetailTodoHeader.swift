//
//  DetailTodoHeader.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

final class DetailTodoHeader: BaseCollectionReusableView {
    // MARK: - View
    private let startTimeLabel = TimeLabel(style: .standard)
    private let startCircleImageView = CircleImageView(style: .start)
    private let timeLineView = LineView(style: .timeLine)
    private let startHorizontalView = LineView(style: .separator)
    private let startTitleLabel = TitleLabel(style: .start)
    private let expandButton = ExpandButton()

    // MARK: - Configure
    func configure(_ todoSection: TodoSection) {
        startTimeLabel.text = todoSection.startTime
        startTitleLabel.setTitle(
            category: todoSection.category,
            title: todoSection.title
        )
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        expandButton.addTarget(self, action: #selector(didTapExpandButton), for: .touchUpInside)
    }

    @objc func didTapExpandButton(_ sender: ExpandButton) {
        sender.isSelected.toggle()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            startTimeLabel,
            startCircleImageView,
            timeLineView,
            startHorizontalView,
            startTitleLabel,
            expandButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        startTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }

        startCircleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(startTimeLabel)
            make.leading.equalTo(startTimeLabel.snp.trailing).offset(8)
        }

        timeLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalTo(startCircleImageView)
            make.verticalEdges.equalToSuperview()
        }

        startHorizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(startTimeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
            make.trailing.equalTo(startTitleLabel.snp.leading).offset(-4)
        }

        startTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLineView.snp.trailing).offset(20)
            make.centerY.equalTo(startTimeLabel)
        }

        expandButton.snp.makeConstraints { make in
            make.centerY.equalTo(startTimeLabel)
            make.trailing.bottom.equalToSuperview()
        }
    }
}
