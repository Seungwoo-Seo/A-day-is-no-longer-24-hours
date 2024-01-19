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
- [🛠 구현 기술](#-구현-기술) 
- [💻 기술 스택](#-기술-스택)
- [📱 서비스](#-서비스)
- [🚨 트러블 슈팅](#-트러블-슈팅)
- [📝 회고](#-회고)

## 🚀 주요 기능

- 취침 시각과 수면 시각 설정
- 수면 시간 기반으로 하루를 최적회된 일수로 자동 분할
- Todo 목록 및 상세 Todo 조회
- Todo 추가 가능 여부

## 🛠 구현 기술

- `Realm`을 활용해 `Todo CRUD` 구현
- `DiffableDataSource`를 활용해 `타임라인` 구현
- `DiffableDataSource`를 활용해 `Expandable Section` 구현

## 💻 기술 스택

- `Swift`
- `MVVM`, `Singleton`
- `UIKit`
- `CodeBase UI`, `AutoLayout`
- `Observable`, `DiffableDataSource`, `CompositionalLayout`
- `Realm`, `SnapKit`, `FSCalendar`, `HGCircularSlider`, `IQKeyboardManager`, `Tabman`

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023년 9월 28일 ~ 2023년 10월 28일 (1개월)

## 🚨 트러블 슈팅

<!-- 프로젝트 중 발생한 문제와 그 해결 방법에 대한 내용을 기록한다. -->
### 1. Realm Object 모델을 Diffable DataSource의 Item으로 직접 사용했을 때 이슈
- **문제 상황**</br>
첫 화면에서 Diffable DataSource를 사용해
~~~swift
~~~

### 2. TableView에 DiffableDataSource를 사용했을 때 tableViewCell에 textField를 사용했을 
- **문제 상황**</br>
- **해결 방법**</br>
~~~swift
~~~

### 2. 
- **문제 상황** </br>
- **해결 방법** </br>
~~~swift
~~~

## 📝 회고
<!-- 프로젝트를 마무리하면서 느낀 소회, 개선점, 다음에 시도해보고 싶은 것 등을 정리한다. -->
프로젝트를 마무리하면서 몇 가지 느낀 점과 개선할 사항들을 회고로 정리하겠습니다.

👍 **성취한 점**
1. Observable을 직접 구현배 

🤔 **개선할 점**
1. ****</br>
2. ****</br>


