<img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/2d1de35c-655e-4d92-ad02-588512fee4a6" width="80"></br>
# 하루는 더 이상 24시간이 아니다

> 하루를 n일로 나눠서 n배 효율적인 하루를 계획할 수 있는 서비스
  
<p align="center">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/4f9f91b9-3cc4-4c9d-8e5a-4ffc1558c805" width="110">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/820b5685-901d-441d-9fc5-06e15592ed62" width="110">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/9c1cd1f0-8e28-45d1-b905-3579485613d2" width="110">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/526e0317-850f-4fcd-a1a7-90ee5dcdb07c" width="110">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/900a0ce0-3429-4bf4-ac50-c7c85563c553" width="110">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/427e1925-5fbe-457f-a593-ac96cb6cc836" width="110">
  <img src="https://github.com/Seungwoo-Seo/A-day-is-no-longer-24-hours/assets/72753868/960e2bed-09b0-4358-9e15-9601b280ea1a" width="110">
</p>

## 목차

- [🚀 주요 기능](#-주요-기능)
- [🛠 구현 기능](#-구현-기능) 
- [💻 기술 스택](#-기술-스택)
- [📱 서비스](#-서비스)
- [🚧 기술적 도전](#-기술적-도전)
- [🚨 트러블 슈팅](#-트러블-슈팅)
- [📝 회고](#-회고)

## 🚀 주요 기능

- 취침 시각과 수면 시각 설정
- 수면 시간 기반으로 하루를 최적회 된 일수로 자동 분할
- Todo 목록 및 상세 Todo 조회
- Todo 추가 가능 여부 검사

## 🛠 구현 기능

- `Realm` DB Table 스키마 구성
- `DiffableDataSource`를 활용해 `Expandable Timeline` 구현
- `데이터 바인딩`을 위한 `Observable` 구현

## 💻 기술 스택

- `Swift`
- `MVVM`, `Repository`, `Singleton`
- `UIKit`
- `CodeBase UI`, `AutoLayout`
- `DiffableDataSource`, `CompositionalLayout`
- `Realm`, `SnapKit`, `FSCalendar`, `HGCircularSlider`, `IQKeyboardManager`, `Tabman`
- `CustomObservable`

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023년 9월 28일 ~ 2023년 10월 28일 (1개월)

## 🚧 기술적 도전

### 1. `데이터 바인딩`을 위한 `Observable` 구현
- **도전 상황**</br>
뷰 컨트롤러와 뷰 모델 사이의 의존성을 느슨하게 하기 위해서 `데이터 바인딩`이 필요했고 클로저를 이용한 `Observable`을 도입해 보았습니다.

- **도전 결과**</br>
~~~swift
import Foundation

final class CustomObservable<T> {
    private var listener: ((T) -> ())?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(
        subscribeNow: Bool = true,
        _ closure: @escaping ((T) -> ())
    ) {
        if subscribeNow {
            closure(value)
        }
        listener = closure
    }

}
~~~


## 🚨 트러블 슈팅

<!-- 프로젝트 중 발생한 문제와 그 해결 방법에 대한 내용을 기록한다. -->

### 1. `textField`를 통해 DiffableDataSource `item`을 업데이트할 때마다 `snapshot`이 변경되는 이슈
- **문제 상황**</br>
아래 사진처럼 자세한 할 일을 추가할 때마다 각 셀에서 사용할 item을 뷰모델에서 배열로 가지고 있고 뷰컨에서는 아래 코드와 같이 item 배열이 변할 때마다 snapshot을 업데이트 해주고 있습니다. 그런데 textField에 입력을 해서 text가 변경될 때마다 snapshot이 변경되어버리는 이슈가 발생했습니다.

<img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/7eca1581-a386-48cf-b5ad-660d8e599195" width="200"></br>
~~~swift
override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.detailTodoList.bind { [weak self] (detailTodoList) in
            guard let self else {return}

            var snapshot = NSDiffableDataSourceSnapshot<TodoContentWritingTableViewSection, DetailTodo>()
            snapshot.appendSections(TodoContentWritingTableViewSection.allCases)
            snapshot.appendItems(detailTodoList, toSection: .detail)
            self.dataSource.apply(snapshot)
        }
}
~~~

- **문제 원인**</br>
textField의 text값을 item의 프로퍼티로 가지고 있는데 item이 `구조체`이기 때문에 text 값을 변경하면 해당 item 또한 변경된 것이기 때문에 snapshot이 업데이트 된 것이였습니다.

- **해결 방법**</br>
사용할 item을 구조체가 아닌 `클래스`로 변경했습니다. item이 새로 추가, 삭제 될 때만 snapshot을 업데이트하고, text값이 변경될 땐 snapshot이 변경되지 않게 되었습니다.

## 📝 회고
<!-- 프로젝트를 마무리하면서 느낀 소회, 개선점, 다음에 시도해보고 싶은 것 등을 정리한다. -->
- 출시 플로우 경험
- MVVM 패턴을 적용
- 기능이 추가되고 생각보다 복잡했던 로직들로 인해 예상 했던 공수 산정보다 훨씬 더 긴 시간이 소요됐습니다. 프로젝트를 진행함에 있어서 기능을 구현하는 것이 물론 중요하지만 초기 기획이 디테일 할수록 정확한 공수 산정과 생산적인 개발을 가능케 한다라는 것을 경험하게 되었습니다.
