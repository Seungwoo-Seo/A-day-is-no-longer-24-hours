//
//  DetailTodoCell.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

final class DetailTodoCell: BaseCollectionViewCell {
    // MARK: - View
    private let eyewashTimeLabel = TimeLabel(style: .eyewash)
    private let eyewashCircleImageView = CircleImageView(style: .eyewash)
    private let timeLineView = LineView(style: .timeLine)
    private let eyewashHorizontalView = LineView(style: .eyewash)
    private let stateButton = StateButton()
    private let titleLabel = TitleLabel(style: .todo)

    // MARK: - Configure
    func configure(_ detailTodo: DetailTodoStruct) {
        titleLabel.text = detailTodo.text
    }

    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        [
            eyewashTimeLabel,
            eyewashCircleImageView,
            timeLineView,
            eyewashHorizontalView,
            stateButton,
            titleLabel
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        eyewashTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview().inset(8)
        }

        eyewashCircleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(eyewashTimeLabel)
            make.leading.equalTo(eyewashTimeLabel.snp.trailing).offset(8)
        }

        timeLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalTo(eyewashCircleImageView)
            make.verticalEdges.equalToSuperview()
        }

        eyewashHorizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(eyewashTimeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-4)
        }

        stateButton.snp.makeConstraints { make in
            make.centerY.equalTo(eyewashTimeLabel)
            make.leading.equalTo(eyewashHorizontalView)
            make.trailing.equalTo(titleLabel.snp.leading)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(stateButton.snp.trailing)
            make.centerY.equalTo(eyewashTimeLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }

}
