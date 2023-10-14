//
//  DateDivideViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/13.
//

import Foundation

final class DateDivideViewModel {
    let dayDivideValueList: Observable<[Int]> = Observable([])
    let lifeTime: Observable<Int?> = Observable(nil)
    let dayDivideValue: Observable<Int> = Observable(1)

    let prevButtonTapped = Observable(false)
    let dateDivideSelectButtonTapped = Observable(false)

    init() {
        lifeTime.bind { lifeTime in
            guard let lifeTime else {return}

            // 이 로직을 통해서 분기를 계산해서 선택하게 하는거지 왜? -> "하루"는 내일이건, 어제건 몇 주, 몇 달, 몇 년 상관없이 동일하기 때문에
            // "며칠로" 나눈다는 개념은 -> 동일한 시간으로 나눈다는 것과 같은 말이다.
            let originHour = lifeTime / 60
            let dayDivideValueList = self.findDivisors(of: lifeTime).filter({$0 <= originHour}).sorted(by: <)

            self.dayDivideValueList.value = dayDivideValueList
            print("약수: \(dayDivideValueList)")
        }
    }

    func findDivisors(of number: Int) -> [Int] {
        var divisors: [Int] = []

        for potentialDivisor in 1...Int(sqrt(Double(number))) {

            if number % potentialDivisor == 0 {
                divisors.append(potentialDivisor)

                // number를 potentialDivisor로 나눈 결과가 potentialDivisor가 아닌 경우 (대칭의 약수)
                if potentialDivisor != number / potentialDivisor {
                    divisors.append(number / potentialDivisor)
                }
            }
        }

        return divisors
    }

    func didSelectRow(_ row: Int) {
        dayDivideValue.value = dayDivideValueList.value[row]
    }

}

// MARK: - UIPickerViewDataSource
extension DateDivideViewModel {

    var numberOfComponents: Int {
        return 1
    }

    var numberOfRowsInComponent: Int {
        return dayDivideValueList.value.count
    }
}

// MARK: - UIPickerViewDelegate
extension DateDivideViewModel {

    func attributedTitleForRow(_ row: Int) -> NSAttributedString {
        return NSAttributedString(
            string: "\(dayDivideValueList.value[row])",
            attributes: [.foregroundColor: Constraints.Color.white]
        )
    }

}
