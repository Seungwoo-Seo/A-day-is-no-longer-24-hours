//
//  DividedDay.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/23.
//

import Foundation
import RealmSwift

final class DividedDay: EmbeddedObject {
    /// 나눠진 하루 식별자, 0부터 시작
    @Persisted var day: Int
    /// 나눠진 하루의 시작시간
    @Persisted var whenIsStartTime: Int
    /// 나눠진 하루의 종료 시각
    @Persisted var whenIsEndTime: Int
    /// 나눠진 하루의 생활 시간
    @Persisted var howMuchLivingTime: Int

    @Persisted var todoList = List<Todo>()

    convenience init(day: Int, whenIsStartTime: Int, whenIsEndTime: Int, howMuchLivingTime: Int) {
        self.init()
        self.day = day
        self.whenIsStartTime = whenIsStartTime
        self.whenIsEndTime = whenIsEndTime
        self.howMuchLivingTime = howMuchLivingTime
    }

    var startTime: (startHour: Int, startMinute: Int) {
        let startHour = whenIsStartTime / 60
        let startMinute = whenIsStartTime % 60
        return (startHour, startMinute)
    }

    var endTime: (endHour: Int, endMinute: Int) {
        let endHour = whenIsEndTime / 60
        let endMinute = whenIsEndTime % 60
        return (endHour, endMinute)
    }

    var livingTime: (livingHour: Int, livingMinute: Int) {
        let livingHour = howMuchLivingTime / 60
        let livingMinute = howMuchLivingTime % 60
        return (livingHour, livingMinute)
    }

    // 아 ㅅㅂ 욕나오네 -> 9가지 경우가 나와야함
    var startTimeToString: String {
        let startHour = startTime.startHour
        let startMinute = startTime.startMinute

        if startHour == 0 {
            if startMinute == 0 {   // ==> 24시가 기상 시간일 경우
                return "00:00"
            } else {
                if startMinute < 10 {
                    return "00:0\(startMinute)"
                } else {
                    return "00:\(startMinute)"
                }
            }
        } else {
            if startMinute == 0 {
                if startHour < 10 {
                    return "0\(startHour):00"
                } else {
                    return "\(startHour):00"
                }
            } else {
                if startHour < 10 {
                    if startMinute < 10 {
                        return "0\(startHour):0\(startMinute)"
                    } else {
                        return "0\(startHour):\(startMinute)"
                    }
                } else {
                    if startMinute < 10 {
                        return "\(startHour):0\(startMinute)"
                    } else {
                        return "\(startHour):\(startMinute)"
                    }
                }
            }
        }
    }

    var endTimeToString: String {
        let endHour = endTime.endHour
        let endMinute = endTime.endMinute

        // MARK: - endHour는 0이 나올 수 없지 않나 아마 1440(24)이 더해져서 0이 나올 수가 없을텐데..
        // 아 대가리 안돌아가네;
        if endHour == 0 {
            if endMinute == 0 {
                return "24:00"
            } else {
                if endMinute < 10 {
                    return "24:0\(endMinute)"
                } else {
                    return "24:\(endMinute)"
                }
            }
        } else {
            if endMinute == 0 {
                if endHour < 10 {
                    return "0\(endHour):00"
                } else {
                    return "\(endHour):00"
                }
            } else {
                if endHour < 10 {
                    if endMinute < 10 {
                        return "0\(endHour):0\(endMinute)"
                    } else {
                        return "0\(endHour):\(endMinute)"
                    }
                } else {
                    if endMinute < 10 {
                        return "\(endHour):0\(endMinute)"
                    } else {
                        return "\(endHour):\(endMinute)"
                    }
                }
            }
        }
    }

    var livingTimeToString: String {
        let livingHour = livingTime.livingHour
        let livingMinute = livingTime.livingMinute

        if livingHour == 0 {
            // livingHour, livingMinute 둘 다 0인 경우는 없다
            // 왜냐면 나눠진 하루의 생활시간이 0이 나올 수 없기 떄문
            return "\(livingMinute)분"
        } else {
            if livingMinute == 0 {
                return "\(livingHour)시간"
            } else {
                return "\(livingHour)시간 \(livingMinute)분"
            }
        }
    }



    /// 나눠진 해당 하루에서 사용하는 "시" 배열
    var whenIsUseHourList: [Int] {
        let startHour = whenIsStartTime / 60
        let endHour = whenIsEndTime / 60

        if whenIsEndTime % 60 != 0 {
            return [Int](startHour...endHour)
        } else {
            // 만약 끝 시간이 막 18:00, 19:00 이런식으로
            // 딱 떨어진다면 18:00를 시작 시간으로 둘꺼냐?
            // 암만 못해도 최소 1분은 할 수 있게
            // 시작 시간을 17:59분으로 잡을 수 있게 하기 위해서
            // 일케 해주면 별다른 검증 로직 필요없겠지
            return [Int](startHour..<endHour)
        }
    }

    // whenIsStartTime에 해당
    // 각 시에서 사용할 수 있는 분 구해주는 메서드
    func minuteAvailableFromUseHour(_ hour: Int) -> [Int] {
        if whenIsUseHourList.first == hour {
            let startMinute = whenIsStartTime % 60
            return [Int](startMinute...59)
        } else if whenIsUseHourList.last == hour {
            if whenIsUseHourList.last == whenIsEndTime / 60 {
                let endMinute = whenIsEndTime % 60
                if endMinute == 0 {
                    return [Int](0...endMinute)
                } else {
                    return [Int](0...endMinute-1)
                }
            } else {
                return [Int](0...59)
            }
        } else {
            return [Int](0...59)
        }
    }

    func whenIsUseHourMinuteList() -> [(Int, [Int])] {
        var results: [(Int, [Int])] = []
        whenIsUseHourList.forEach {
            let minutes = minuteAvailableFromUseHour($0)
            results.append(($0, minutes))
        }
        return results
    }

    var whenIsTodoStartTimeFirstValue: (Int, Int) {
        let first = whenIsUseHourMinuteList().first!
        let firstMinute = first.1.first!
        return (first.0, firstMinute)
    }

    var livingHourSplitList: [Int] {
        let livingHour = howMuchLivingTime / 60
        return [Int](0...livingHour)
    }

    // howMuchTime에 해당 여기는
    func minuteAvailableFromLivingHour(_ hour: Int) -> [Int] {
        if livingHourSplitList.first == hour {  // 항상 0이니까
            return [Int](1...59)
        } else if livingHourSplitList.last == hour {
            let endMinute = howMuchLivingTime % 60
            return [Int](0...endMinute)
        } else {
            return [Int](0...59)
        }
    }

    func livingHourMinuteList() -> [(Int, [Int])] {
        var results: [(Int, [Int])] = []
        livingHourSplitList.forEach {
            let minutes = minuteAvailableFromLivingHour($0)
            results.append(($0, minutes))
        }
        return results
    }

    var howMuchTodoTimeFirstValue: (Int, Int) {
        let first = livingHourMinuteList().first!
        let firstMinute = first.1.first!
        return (first.0, firstMinute)
    }
}

