//
//  DefaultDivideCofigViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/13.
//

import Foundation

final class DefaultDivideCofigViewModel {
    // TODO: 여기서 howMuchLivingTime 제거하고 해볼 것. 굳이 없어도 될 듯
    /// 생활 시간, "분"으로 변환한 값
    let howMuchLivingTime = Observable(1080) // 18시간 ===> 얘가 꼭 있을 필요가 없을꺼 같네
    /// 생활 시간을 나눌 수 있는 값(일수)들
    let divideValueList = Observable(
        [1, 2, 3, 4, 5, 6, 9, 10, 12, 15, 18]   // ====> 얘만 받으면 되니까
    )
    /// 현재 선택한 나눌 값
    let currentDivideValue = Observable(1)

    // MARK: - Event, bind from OnboardingTabViewController
    /// "이전으로" 버튼 탭 이벤트
    let prevButtonTapped = Observable(false)
    /// "n일로 나누고 시작하기" 버튼 탭 이벤트
    let divideAndStartButtonTapped = Observable(false)

    // MARK: - Init
    init() {
        howMuchLivingTime.bind { [weak self] (howMuchLivingTime) in
            guard let self else {return}
            self.updateDivideValueList(howMuchLivingTime: howMuchLivingTime)
        }
    }

}

// MARK: - UIPickerViewDataSource
extension DefaultDivideCofigViewModel {

    var numberOfComponents: Int {
        return 1
    }

    var numberOfRowsInComponent: Int {
        return divideValueList.value.count
    }
}

// MARK: - UIPickerViewDelegate
extension DefaultDivideCofigViewModel {

    func attributedTitleForRow(_ row: Int) -> NSAttributedString {
        return NSAttributedString(
            string: "\(divideValueList.value[row])",
            attributes: [.foregroundColor: Constraints.Color.white]
        )
    }

    func didSelectRow(_ row: Int) {
        currentDivideValue.value = divideValueList.value[row]
    }

}

// MARK: - 비즈니스
private extension DefaultDivideCofigViewModel {

    /// 약수 찾는 메서드
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

    /// divideValueList를 업데이트 해주는 메서드
    func updateDivideValueList(howMuchLivingTime: Int) {
        // 이 로직을 통해서 분기를 계산해서 선택하게 하는거지 왜? -> "하루"는 내일이건, 어제건 몇 주, 몇 달, 몇 년 상관없이 동일하기 때문에
        // "며칠로" 나눈다는 개념은 -> 동일한 시간으로 나눈다는 것과 같은 말이다.
        // 약수라고 무조건 가능한게 아니라 최대 생활 시간중 "시간"의 값보다 작거나 같은 약수만 가능케 한다.
        // 일단 약수를 사용하면 나눈 날들이 동일한 시간을 가지게 되고
        // 실제 "시간"보다 더 많이 나누게 되면 너무 분기가 잦을 수 있기 때문에
        // 제약을 둠으로써 잦은 분기 방지와 최소 1시간 이상의 분기를 적용케 했다.
        let originHour = howMuchLivingTime / 60
        print(originHour)
        let divideValueList = findDivisors(of: howMuchLivingTime)
            .filter({$0 <= originHour})
            .sorted(by: <)

        self.divideValueList.value = divideValueList
        print("약수: \(divideValueList)")
    }

}
