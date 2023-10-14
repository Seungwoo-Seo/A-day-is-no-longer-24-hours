//
//  Constraints.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

enum Constraints {

    enum Color {
        static let clear = UIColor.clear
        static let black = UIColor.black
        static let white = UIColor.white
        static let green = UIColor.green
        static let red = UIColor.red
        static let darkGray = UIColor.darkGray
        static let lightGray_alpha012 = UIColor.lightGray.withAlphaComponent(0.12)
        static let systemBlue = UIColor.systemBlue
        /// 금색
        static let todayColor = UIColor(red: 255/255, green: 215/255, blue: 0, alpha: 1)

        // timeLabel
        static let timeLabelTextColor = UIColor.white

        // lineView
        static let separatorBackgroundColor = UIColor.white
        static let timeLineBackgroundColor = UIColor.white

        // circleImageView
        static let circleImageViewTintColor = UIColor.white

        // titleLabel
        static let titleLabelTextColor = UIColor.white
    }

    // Font는 레이아웃과 연관있기 때문에 변경 시 이슈가 생길 가능성이 있다.
    // 따라서 두 가지의 경우가 필요
    enum Font {
        /// 변경해도 큰 이슈가 없음
        enum Insensitive {
            static let category = UIFont.systemFont(ofSize: 17, weight: .bold)
            static let title = UIFont.systemFont(ofSize: 17, weight: .regular)
            static let systemFont_17_semibold = UIFont.systemFont(ofSize: 17, weight: .semibold)
            static let systemFont_24_semibold = UIFont.systemFont(ofSize: 24, weight: .semibold)
        }

        /// 변경했을 때 큰 이슈가 생길 수 있음
        enum Sensitive {
            static let time = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }

}
