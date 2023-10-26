//
//  DetailTodoFooter.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

final class DetailTodoFooter: BaseCollectionReusableView {
    // MARK: - View
    private let endTimeLabel = TimeLabel(style: .standard)
    private let endCircleImageView = CircleImageView(style: .end)
    private let timeLineView = LineView(style: .timeLine)
    private let endHorizontalView = LineView(style: .separator)
    private let endTitleLabel = TitleLabel(style: .end)

    // MARK: - Configure
    func configure(_ todo: TodoStruct) {
        endTimeLabel.text = todo.endTimeToString
        endTitleLabel.text = "마감"
    }

    // MARK: - Initial Setting
    override func initialHierarchy() {
        super.initialHierarchy()

        [
            endTimeLabel,
            endCircleImageView,
            timeLineView,
            endHorizontalView,
            endTitleLabel
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        endTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }

        endCircleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(endTimeLabel)
            make.leading.equalTo(endTimeLabel.snp.trailing).offset(8)
        }

        timeLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalTo(endCircleImageView)
            make.verticalEdges.equalToSuperview()
        }

        endHorizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(16)
            make.centerY.equalTo(endTimeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
        }

        endTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(endHorizontalView.snp.trailing).offset(4)
            make.centerY.equalTo(endTimeLabel)
        }
    }

}
