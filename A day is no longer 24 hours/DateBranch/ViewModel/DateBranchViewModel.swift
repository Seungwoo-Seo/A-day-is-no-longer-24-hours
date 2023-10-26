//
//  DateBranchViewModel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/08.
//

import Foundation

final class DateBranchViewModel {
    // 캘린더에서 선택한 날짜들
    var dateList: Observable<[Date]> = Observable([])
    // 선택한 날짜들이 모두 유효하다면 -> 수면 시간과 기상 시간을 설정하게 할 것
    var dateListIsVaildate = Observable(false)
    // 취침 시간
    var bedTime: Observable<Date?> = Observable(nil)
    // 기상 시간
    var wakeUpTime: Observable<Date?> = Observable(nil)


    var bedTimeComponents: Observable<DateComponents?> = Observable(nil)
    var wakeUpTimeComponents: Observable<DateComponents?> = Observable(nil)


    var bedTimeCalendar: Observable<Calendar?> = Observable(nil)
    var wakeUpTimeCalendar: Observable<Calendar?> = Observable(nil)

    var dateBranchKindList: Observable<[Int]> = Observable([])

}

extension DateBranchViewModel {

    // 이 안에 날짜들이 유효한지 검사해야함
    func dateListVaildation(_ list: [Date]) {
        // 파라미터로 전달 받은 날짜 리스트가
        // 렘에 저장되어 있는지 아닌지 체크를 하고
        dateListIsVaildate.value = true
    }

    func sleepTimeVaildation() {
        guard let bedTime = bedTimeComponents.value else {return}
        guard let wakeUpTime = wakeUpTimeComponents.value else {return}

        print(bedTime.date!)
        print(wakeUpTime.date!)
        let a = ampmtest(dateComponents: bedTime)
        let b = ampmtest(dateComponents: wakeUpTime)


        // 제일 간단한건 기상 시간말고 취침 시간을 물어보고 얼마나 잘건지를 물어보는게 로직적으로 매우 간단할듯
        // 오전 -> 오전
        if a == true && b == true {
            if wakeUpTime.date! > bedTime.date! {
                print(wakeUpTime.hour)
                print(bedTime.hour)
                let test = Calendar.current.date(
                    byAdding: .hour,
                    value: -(wakeUpTime.hour! - bedTime.hour!),
                    to: wakeUpTime.date!
                )


//                wakeUpTime.date - bedTime.date
                print("test -> ", test)
                print("1")
            } else if wakeUpTime.date! == bedTime.date! {
                print("2")
                print("취침 시간과 기상 시간이 동일해요!")
            } else {
                print("3")
                // 잠을 존나게 잔다는 소린데
                // (24:00 - bedTime) + wakeUpTime
                print("생활 시간보다 수면 시간이 너무 길지 않나요?")
            }
        }
        // 오전 -> 오후
        else if a == true && b == false {
            // 여기선 시간이 같은 케이스도 절대 안나오고 반대되는 상황도 나올 수가 없지
            // wakeupTime - bedTime
            print("4")
        }
        // 오후 -> 오후
        else if a == false && b == false {
            if wakeUpTime.date! > bedTime.date! {
                print("5")
                // wakeupTime - bedTime
            } else if wakeUpTime.date! == bedTime.date! {
                print("6")
                print("취침 시간과 기상 시간이 동일해요!")
            } else {
                print("7")
                // 잠을 존나게 잔다는 소린데
                // (24:00 - bedTime) + wakeUpTime
                print("생활 시간보다 수면 시간이 너무 길지 않나요?")
            }
        }
        // 오후 -> 오전
        else {
            print("8")
            //(24:00 - bedTime) + wakeupTime
        }

        //8가지
    }

    // true = 오전, false = 오후
    func ampmtest(dateComponents: DateComponents) -> Bool {
        if (0...11).contains(dateComponents.hour!) {
            // 오전
            return true
        } else {
            // 오후
            return false
        }
    }

}

// MARK: - Picker
extension DateBranchViewModel {

    enum TimeSection: Int, CaseIterable {
        case 전후
        case hour
        case minitue

        var test: [Int] {
            switch self {
            case .전후: return [0, 1]
            case .hour: return [Int](1...12)
            case .minitue: return [00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
            }
        }

        func 전후text(data: Int) -> String {
            if data == 0 {
                return "오전"
            } else {
                return "오후"
            }
        }
    }

    var numberOfComponents: Int {
        return TimeSection.allCases.count
    }

    func numberOfRowsInComponent(_ component: Int) -> Int {
        let section = TimeSection.allCases[component]
        section.test.count
        return dateBranchKindList.value.count
    }

    func titleForRow(_ row: Int) -> String {
        return "\(dateBranchKindList.value[row])일"
    }

}
