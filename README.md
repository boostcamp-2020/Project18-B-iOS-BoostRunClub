<p align="center">
<img src="https://i.imgur.com/cGnIJrd.png">
</p>


사용자의 러닝을 측정 및 기록하여 저장하고, 활동 내역을 정리하여 보여주는 iOS 애플리케이션 입니다.

<br>

## 📱 Preview


| <img src="https://user-images.githubusercontent.com/34773827/101919696-34531180-3c0e-11eb-802f-46d75562746e.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101919701-36b56b80-3c0e-11eb-9f02-a30b4cb32856.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101921009-d58e9780-3c0f-11eb-9f16-d1236e3102a7.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101919696-34531180-3c0e-11eb-802f-46d75562746e.gif" width="400px"> | 
| :-: | :-: | :-: | :-: | 
| **목표 설정 (시간)** | **러닝** |  **러닝 일시정지** | **추가 필요** |

| <img src="https://user-images.githubusercontent.com/34773827/101919663-2b624000-3c0e-11eb-91fb-6df70ccdfbc7.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101919689-31f0b780-3c0e-11eb-998c-6644eb9133b0.gif" width="400px">  | <img src="https://i.imgur.com/oFOie99.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101919696-34531180-3c0e-11eb-802f-46d75562746e.gif" width="400px"> | 
| :-: | :-: | :-: | :-: | 
| **활동** | **모든 활동** |  **프로필** | **추가 필요** |

<br>


## ✨ Feature

### 러닝 
- 사용자의 러닝을 기록하여 그 경로를 지도에 표시합니다.
- 기록된 러닝 정보를 바탕으로 구간 별 페이스, 케이던스 등 측정 자료를 표시합니다.
- 사용자의 움직임을 감지하여 러닝을 일시정지 / 재개할 수 있습니다.

### 활동
- 저장된 러닝 데이터를 주, 월, 년 별로 필터 적용하여 확인이 가능합니다.
- 전체 활동 기록에 대한 통계를 제공합니다.
- 이전에 달린 러닝 경로를 지도에서 확인할 수 있습니다.
- 소모된 칼로리량, 평균페이스, 고도 상승 및 하강 등 러닝 상세 데이터를 확인할 수 있습니다.

<br>

## 🏛 Architecture

MVVM-C Lucid Chart 이용해서 직접 그려보기 (?)

<br>

## 🏗 Framework
- 이건 아래와 같은 리스트형식보다는 그림으로 나중에 수정
- 🎨 UIKit
- ⚙️ Combine
- 📍 CoreLocation
- 🤸‍♀️ CoreMotion
- 💽 CoreData

<br>

## 💪 Challenge


<br>

## 🚗 How to run
- 우선 xcode 12.2 와 cocoapods 설치가 선행되어야 합니다. `brew install cocoapods`
- 설치가 되어있다면, 해당 깃헙 저장소를 로컬 클론해주세요.
- 클론 후 해당 폴더에서 `pod install` 을 실행해주세요.
- 인스톨이 완료된 후에는 `BoostRunClub.xcworkspace` 를 열고, 실행 버튼 혹은 `command + R` 

<br>


## 👨🏻‍💻🧑🏼‍💻👨🏽‍💻 Developers 

| <img src="https://avatars1.githubusercontent.com/u/34773827?s=400&u=5d2fc5bb683e8974b85d82aa58096335b79db6ab&v=4" width="150"> | <img src="https://avatars3.githubusercontent.com/u/46217844?s=460&u=8dc1af018cddf99b1dee7170beac87d0f69c1fa1&v=4" width="150"> | <img src="https://avatars2.githubusercontent.com/u/21030956?s=460&u=3a1ddcfd3e95a67f995b6a4ab00be331c01a9a5c&v=4" width="150"> |
| :-: | :-: | :-: |
|  **S011 김신우**   |  **S046 장임호**  |  **S053 조기현** |
| [@SHIVVVPP](https://github.com/SHIVVVPP)   | [@seoulboy](https://github.com/seoulboy)   | [@whrlgus](https://github.com/whrlgus)     |


<div align="center">

![Swift](https://img.shields.io/badge/swift-v5.3-orange?logo=swift)
![Xcode](https://img.shields.io/badge/xcode-v12.2-blue?logo=xcode)

[![GitHub Open Issues](https://img.shields.io/github/issues-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=green)](https://github.com/boostcamp-2020/Project18-B-iOS-BoostRunClub/issues)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=red)](https://github.com/boostcamp-2020/Project18-B-iOS-BoostRunClub/issues)
[![GitHub Open PR](https://img.shields.io/github/issues-pr-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=green)](https://github.com/boostcamp-2020/Project18-B-iOS-BoostRunClub/issues)
[![GitHub Closed PR](https://img.shields.io/github/issues-pr-closed-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=red)](https://github.com/boostcamp-2020/IProject18-B-iOS-BoostRunClub/issues)


![Contributions welcome](https://img.shields.io/badge/contributions-welcome-green.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

</div>

<!--
<img src="https://user-images.githubusercontent.com/34773827/101919691-3321e480-3c0e-11eb-8a8e-cb7e8cc64d17.gif" width="200px">
<img src="https://user-images.githubusercontent.com/34773827/101919689-31f0b780-3c0e-11eb-998c
-6644eb9133b0.gif" width="200px">
<img src="https://user-images.githubusercontent.com/34773827/101919663-2b624000-3c0e-11eb-91fb-6df70ccdfbc7.gif" width="200px">

<img src="https://user-images.githubusercontent.com/34773827/101919696-34531180-3c0e-11eb-802f-46d75562746e.gif" width="200px">
<img src="https://user-images.githubusercontent.com/34773827/101919701-36b56b80-3c0e-11eb-9f02-a30b4cb32856.gif" width="200px">
<img src="https://user-images.githubusercontent.com/34773827/101919709-387f2f00-3c0e-11eb-8c20-45c855b4fc16.gif" width="200px">
<img src="https://user-images.githubusercontent.com/34773827/101921009-d58e9780-3c0f-11eb-9f16-d1236e3102a7.gif" width="200px">
--!>

