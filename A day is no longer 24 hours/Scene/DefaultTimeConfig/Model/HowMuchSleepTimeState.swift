//
//  HowMuchSleepTimeState.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/11/27.
//

import Foundation

/// 수면시간의 상태
// ex 좋다 4~8시간, 작다 1>, 크다 20<, 좀 많다 9<
enum HowMuchSleepTimeState {

    case available
    case unavailable

    var description: String {
        switch self {
        case .available: return "적절한 수면 시간을 정해보세요!"
        case .unavailable: return "수면 시간이 너무 작거나 너무 큽니다."
        }
    }
}
