<p align="center">🏃‍♀️🏃‍♂️🏃<br><br>


<span align="center"><h2>18-B-iOS 팀의  <span style="color:orange">Nike Run Club</span> 클론 프로젝트 <span style="color:orange">Boost Run Club</span><h2></span>


<img align="center" src="https://i.imgur.com/cGnIJrd.png">

![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)

<br>

## TL;DR
부스트 런 클럽은 사용자의 러닝을 측정하여 데이터를 수집하고, 정제한 러닝 데이터를 바탕으로 생성한 활동내역을 확인할 수 있는 iOS 애플리케이션입니다.

<br>

## Demo Video 📺 

[부스트 런 클럽 데모 영상](https://youtu.be/__UCw7RBZbk)

<br>

## Developers 👨🏻‍💻🧑🏼‍💻👨🏽‍💻
<div style=" display: block;
  margin-left: auto;
  margin-right: auto;
  width: 76%;">


| 🍎 iOS   | 🍏 iOS  |  🍎 iOS  |
| :-: | :-: | :-: |
| <img src="https://avatars1.githubusercontent.com/u/34773827?s=400&u=5d2fc5bb683e8974b85d82aa58096335b79db6ab&v=4" width="150"> | <img src="https://avatars3.githubusercontent.com/u/46217844?s=460&u=8dc1af018cddf99b1dee7170beac87d0f69c1fa1&v=4" width="150"> | <img src="https://avatars2.githubusercontent.com/u/21030956?s=460&u=3a1ddcfd3e95a67f995b6a4ab00be331c01a9a5c&v=4" width="150"> |
|  **`S011` 김신우**   |  **`S046` 장임호**  |  **`S053` 조기현** |
| [@SHIVVVPP](https://github.com/SHIVVVPP)   | [@seoulboy](https://github.com/seoulboy)   | [@whrlgus](https://github.com/whrlgus)     |
|  잠 그게 뭐죠?  |  잠은 자야합니다  |  라면 끓여와도 되죠?  |

<br>


## Table of contents 🌳

- [1. 미리보기](#preview-)  
- [2. 설치 및 실행 방법](#installation-)  
- [3. 기능 목록](#feature-)  
- [4. 프로젝트 구조](#architecture-)  
- [5. 사용한 프레임워크](#framework-)  
- [6. DevOps](#devops-)
- [7. 마주했던 도전거리들을 해결한 이야기](#challenges-)  

<br>

## Preview 📱
>부런클 앱의 미리보기 화면입니다 ✨

| <img src="https://user-images.githubusercontent.com/34773827/101919696-34531180-3c0e-11eb-802f-46d75562746e.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/21030956/102686069-78569f80-4228-11eb-87ff-6c887358dee3.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101921009-d58e9780-3c0f-11eb-9f16-d1236e3102a7.gif" width="400px"> | <img src="https://user-images.githubusercontent.com/34773827/101919663-2b624000-3c0e-11eb-91fb-6df70ccdfbc7.gif" width="400px"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                           `목표설정`                           |                             `러닝`                             |                        `러닝 일시정지`                         |                             `활동`                             |
| <img src="https://user-images.githubusercontent.com/34773827/101919689-31f0b780-3c0e-11eb-998c-6644eb9133b0.gif" width="400px"> | <img src = "https://user-images.githubusercontent.com/34773827/102686101-ad62f200-4228-11eb-8e1e-e3fff229fdb1.gif" width="400px"> | <img src = "https://user-images.githubusercontent.com/34773827/102686924-6d067280-422e-11eb-9ced-31a9aa019f9d.gif" width="400px"> | <img src = "https://user-images.githubusercontent.com/34773827/102686922-611ab080-422e-11eb-84f4-5a211d19d298.gif" width="400px"> |
|                          `모든 활동`                           |                           `활동상세`                          |                           `구간상세`                           |                           `경로상세`                           |


<br>

## Installation 🏃
>부런클을 직접 설치하여 사용해 보세요 ✨

- 우선 xcode 12.2 와 cocoapods 설치가 선행되어야 합니다. `brew install cocoapods`
- 설치가 되어있다면, 저장소의 `Code` 버튼을 클릭하여 해당 깃헙 저장소를 로컬에 클론하시거나 `Open With Xcode`를 클릭해주세요. 
- 클론 후에는 해당 폴더에서 `pod install` 을 실행해주세요.
- 인스톨이 완료된 후에는 `BoostRunClub.xcworkspace` 를 열고, 실행 버튼 혹은
 실행 단축키 `command + R` 을 눌러서 실행해주세요.

<br>

## Feature 💫
>부런클에 담은 기능 목록입니다 ✨

### 러닝 기능
- 사용자의 러닝을 기록하여 그 `경로를 지도에 표시`합니다.
- 기록된 러닝 정보를 바탕으로 구간 별 페이스, 케이던스 등 `측정 자료를 표시`합니다.
- 사용자의 `움직임을 감지`하여 러닝을 자동으로 일시정지 / 재개할 수 있습니다.

### 활동 기능
- 저장된 러닝 데이터를 주, 월, 년 별로 `필터 적용`하여 확인이 가능합니다.
- 전체 활동 기록에 대한 `통계를 제공`합니다.
- `이전에 달린 러닝 경로`를 지도에서 확인할 수 있습니다.
- 소모된 칼로리량, 평균페이스, 고도 상승 및 하강 등 `러닝 상세 데이터`를 확인할 수 있습니다.


### UI/UX
- 화면 전환/버튼 클릭 시 반응하는 뷰에 `애니메이션` 및 `햅틱 피드백`을 적용하였습니다.
- 컬러 에셋을 사용하여 `다크모드`를 지원하도록 구현하였습니다.
- `AVFoundation` framework의 `AVSpeechSynthesizer`를 사용하여 `음성 피드백`을 제공합니다.
- 러닝 시작/일시정지/러닝, 목표 달성 시에 사용자에게 음성으로 알려주어 사용성을 높입니다.

### Dark Mode

<img src="https://user-images.githubusercontent.com/34773827/102692748-c8e5f100-4258-11eb-9eb7-0846808ec74c.png" width="225"><img src="https://user-images.githubusercontent.com/34773827/102692750-d0a59580-4258-11eb-9bf8-24220172c05d.png" width="225">

<details>
<summary>👈 더보기</summary>

| <div><img src="https://user-images.githubusercontent.com/34773827/102692550-6dffca00-4257-11eb-9c61-6cf952b653e4.png" width="195"><img src="https://user-images.githubusercontent.com/34773827/102692544-60e2db00-4257-11eb-81ab-270504a2d629.png" width="195"></div> | <div><img src="https://user-images.githubusercontent.com/34773827/102692645-08f8a400-4258-11eb-9218-e8cd96fbec45.png" width="195"><img src="https://user-images.githubusercontent.com/34773827/102692641-01d19600-4258-11eb-9de6-9a330ad203f5.png" width="195"></div> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                        `러닝 일시정지`                         |                           `활동`                            |
| <div><img src="https://user-images.githubusercontent.com/34773827/102692613-cc2cad00-4257-11eb-98ff-f579c52fd447.png" width="195"><img src="https://user-images.githubusercontent.com/34773827/102692598-b7e8b000-4257-11eb-8dc6-3b2de619a89c.png" width="195"></div> | <div><img src="https://user-images.githubusercontent.com/34773827/102692632-ec5c6c00-4257-11eb-9275-89e7d5899a5e.png" width="195"><img src="https://user-images.githubusercontent.com/34773827/102692633-f54d3d80-4257-11eb-91a5-126f3dc2535e.png" width="195"></div> |
|                           `활동상세`                           |                           `구간상세`                           |
</details>





<br>

## Architecture 🏛
>부런클에서 사용하고 있는 프로젝트 구조를 보기 쉽게 한눈에 그려보았습니다 ✨

![리드미 001](https://user-images.githubusercontent.com/34773827/102685609-56a7e900-4225-11eb-85e0-6e34407bfdc7.jpeg)

<br>

## Framework 🏗
>부런클 제작에는 외부패키지를 사용하지 않고 애플에서 제공하는 프레임워크만 사용하였습니다. ✨

![333 001](https://user-images.githubusercontent.com/46217844/102346327-01c86080-3fe2-11eb-9660-e5e4505d6427.jpeg)

<br>

## DevOps 📈

### Github Actions를 이용한 지속적 통합 (Continuous Integration)

`Github Actions`를 이용하여 테스트 및 빌드를 자동화하였고, PR을 merge하기 전에 빌드나 테스트가 올바르게 실행이 되는지 손쉽게 확인할 수 있었습니다. 이를 통해 빌드가 되지 않는 코드를 신속하게 확인하고 수정할 수 있었습니다.


### Slack + Github Integration을 이용한 ChatOps 활용 

부스트캠프 Slack에 프로젝트에 대한 Github 알림을 받을 채널을 생성하고 Github App을 통해 프로젝트 저장소와 연동하였습니다.

부스트 런 클럽 프로젝트 저장소에서 일어나는 다양한 활동을 실시간으로 알림 받고, 이를 통해 각 팀원들의 활동 내역을 보다 더 편리하고 빠르게 확인하며 팀의 생산성을 높이고자 노력했습니다. 

## Challenges 💪
>부런클 제작 과정에 있어 저희가 마주했던 도전과제들과 문제를 해결했던 경험을 공유합니다 ✨

### A. `코디네이터 패턴 도입, 뷰컨트롤러 간 데이터 전달 및 뷰 전환`


코디네이터 패턴에서 뷰 전환 로직은 모두 코디네이터 객체가 수행합니다. 프로젝트에 코디네이터 패턴을 적용하여 역할을 분리해 보고자 하였습니다. 따라서 **다른 뷰로 전환하는 로직**이나, **전환 시 넘겨줄 필요가 있는 데이터 전달 로직**은 코디네이터 객체를 통해 수행하는 방향으로 설계해야 했습니다. 

<details> 
 <summary style="color:blue">👈 더보기</summary>
 <br> 

크게 두 가지 상황으로 구분하여 다음과 같은 방식으로 이를 구현해내었습니다.
  1. 뷰모델과 코디네이터 바인딩
  하나의 코디네이터 객체를 통해 뷰를 전환하고, 뷰간 데이터를 전달하는 경우에는 코디네이터와 각 뷰모델 간에 바인딩을 통해 이를 처리할 수 있게 구현했습니다.
  2. NotificationCenter 
  코디네이터를 트리 구조로 표현할 때, 하위 코디네이터에서 다른 노드의 하위 코디네이터로 이동하는 경우가 있습니다. 이때, 경로에 있는 모든 코디네이터를 바인딩 하거나 델리게이트를 사용하지 않고 노티피케이션으로 알려주어, 이를 옵저빙 하는 곳에서 바로 처리할 수 있게 구현하였습니다.

 <br> 

  </details>


### B. `러닝 데이터 처리를 위한 데이터 구조 설계(running split, slice)`


러닝을 시작했을 때, 사용자는 1KM 단위로 자신이 뛴 통계 정보를 볼 수 있어야 합니다.
이런 단위를 기준으로 먼저 러닝에 대한 정보를 RunningSplit으로 나누었습니다.

<details>
<summary style="color:green">👈 더보기 </summary>

 <br> 
 
RunningSplit을 통해 사용자는 자신이 뛴 경로와 정보를 볼 수 있었지만 한가지 문제가 되었던 사항은 러닝 중지 상태에서의 위치정보는 기록하지 않아 경로를 그릴 때 러닝 중지한 시점과 러닝을 시작한 시점이 선으로 이어지는 것이었습니다.

해결 방안으로 Running Slice 라는 데이터 구조를 도입했습니다. Running Split이 1KM 단위로 러닝을 구분한 것이었다면 Running Slice는 이벤트 단위로 러닝을 나눈 것입니다.(주로 Running 여부를 기준으로 나뉩니다.)

Running Slice는 저장해두고있는 Location 배열에서 Slice의 시작 위치 끝 위치를 가지고 있으며
이를 통해서 Running Split 경로를 그릴 때 RunningSlice 배열 정보를 통해 어색하지 않은 경로를 그릴 수 있게 되었고, 더 나아가 러닝상태에서의 경로와 러닝상태가 아닐 때의 경로를 모두 표시하고 색으로 구분하여 더 나은 사용성을 제공할 수 있게 되었습니다.


 ![image](https://user-images.githubusercontent.com/34773827/102685647-8eaf2c00-4225-11eb-9797-bba196b66b27.png)

 <br> 

</details>


### C. `일정간격으로 들어오지 않는 CoreLocation 정보를 일정하게 받기`

처음 프로젝트를 기획 할 때, 기기에서 위치정보는 일정 시간간격으로 들어오거나 임의로 간격을 설정할 수 있을 줄 알았지만 기기마다 그리고 상태마다 간격이 다르다는 것을 알게되었습니다.

<details>
<summary style="color:purple">👈 더보기 </summary>

<br>

실제 앱 화면에서 시간이 1초간격으로 표시되며 그에 맞게 변경된 데이터들을 표시해야 하기 때문에 이 시간 간격을 컨트롤 할 수 있어야 할 필요가 있었습니다.

이 문제에 대한 해결 방안으로
일정 주기로 `timeIntervalSinceReferenceDate` 이벤트를 전달하는 객체와 `lastUpdated` 라는 업데이트된 시간을 유지하는 객체를 만들어 Location과 이벤트 객체에서 발생하는 이벤트를 받아 최근 업데이트 시간과의 차이를 누적시키고 업데이트 시간을 갱신 해주도록 하여 러닝시간을 정교하게 계산할 수 있으면서 일정하게 정보를 받을 수 있도록 해주었습니다.

<br> 

</details>

### D. `러닝 상태 컨트롤 하기`

저희 프로젝트의 핵심 기능 중 하나는 러닝 상태에 따라 자동으로 화면 전환과,
러닝 여부에 따라 화면에 표시되는 지표들이 변경되는 것입니다.

<details>
<summary style="color:purple">👈 더보기 </summary>

<br>

저희는 이 기능을 효과적으로 처리하기 위해
러닝 서비스를 RunningFlowController, RunningDashBoard, RunningRecorder 로 분리하여 구현하였습니다.
RunningDashBoard는 디바이스의 이벤트를 처리하여 우리가 사용할 러닝 정보로 변환하며 최신 상태를 알리고,
RunningRecorder는 DashBoard의 값이 변경 될 때, 러닝정보를 누적하고 구조화 시킵니다.
RunningFlowController는 사용자 이벤트 및 모션 상태 변화를 감지하여 DashBoard, Recorder에 명령을 내려 흐름을 변경합니다.

이렇게 핵심 기능들을 분리함으로써 저희는 러닝 상태 변화에 따른 다양한 효과들을 구현할 수 있었습니다.

![image](https://user-images.githubusercontent.com/34773827/102685985-dfc01f80-4227-11eb-9525-4756d946e294.png)


<br> 



</details>



### E. `의존성 컨테이너 - 싱글턴으로 구현 vs 주입을 통한 구현`

러닝 데이터를 측정하고 관리하기위한 애플리케이션을 만들다 보니 Core Location 을 감싸는 구체타입 LocationProvider, Core Motion 을 감싸는 구체타입 MotionProvider, 그리고 Core Data를 감싸는 구체타입 RunningDataProvider 등의 여러 구체타입들을 만들게 되었습니다. 각 구체타입에 대한 의존성을 주입하기 위해 ...
<details> 
 <summary style="color:orange">👈 더보기</summary>
 
 <br> 
 
각 구체타입에 대한 의존성을 주입하기 위해 애플리케이션의 의존성들을 한곳에 담아서 필요한 곳에서 꺼내다 쓰는 의존성 컨테이너를 사용하자는 제안이 있었습니다. 그러자 "해당 컨테이너를 애플리케이션 상위부터 하위까지 주입을 하여 구현하자"와 "싱글턴 패턴을 적용하여 사용하자"는 두 의견이 충돌하게 되었습니다. 이틑날 새벽까지 이어진 "싱글턴 vs 주입"에 대한 회의는 결국 일단 주입하는 방법을 사용해보고 차차 개선하는 방향으로 결론을 지었으나 각자 제시했던 의견에 있어 상대를 설득시킬만한 사례나 근거에 대한 준비가 미흡했기 때문에 주입을 활용한 방법에 대한 확신이 부족한 상황이었습니다. 

이에 대한 고민과 토론은 개발 2주차까지 이어지게 되었고, 애플리케이션의 상위구조에서 하위구조까지 차례로 전달해주는 방법은 의존성을 필요로 하지 않는 중간객체가 주입 받게 된다는 단점이 있다는 것을 깨닫게 되었습니다. 중간객체가 단순히 하위구조에 의존성을 전달하기 위해 가지고 있으면, 중간객체는 자신과는 아무런 관련이 없는 의존성 컨테이너를 알고 있게되어 객체의 책임이 불분명해지기 때문에 구현 방법을 변경하기로 결정하였습니다. 의존성을 주입 받는 객체는 싱글턴으로 구현된 의존성 컨테이너를 주입받도록 하면서, 필요한 의존성만 주입받을 수 있도록 알맞은 인터페이스를 추가해주는 방식으로 리팩터링을 하게되었습니다. 

 <br> 

</details>

### F. `Core ML을 이용한 모션 감지 정확도 개선`

걷고 있는 지 뛰고 있는 지, 아니면 가만히 서 있는 지와 같은 사용자 모션에 따라, 러닝 기록 여부를 결정해야 합니다. CMMotionActivity를 활용하면 최대 5가지의 상태를 구분할 수 있지만, 정확도가 너무 낮다는 문제가 있었습니다. 이 문제를 CoreML을 이용해서 해결했습니다.

<details>
 <summary style="color:red">👈 더보기</summary>
이 문제를 CoreML을 이용해서 해결했습니다. 기기 센서를 통해 발생하는 값(attitude, gravity, rotationRate, userAcceleration)을 기반으로 label을 두 가지로 구분할 수 있는 모델을 만들었습니다. 데이터를 수집기를 만들어 두 가지 상태에 따른 데이터 셋을 직접 만들었고, 이러한 과정을 통해 기대하는 값의 정확도를 높일 수 있었습니다. (https://github.com/whrlgus/MotionDataCollector)
  <img src = "https://i.imgur.com/wvEluOT.png"/>
</details>

<br>






<div align="center">

![Swift](https://img.shields.io/badge/swift-v5.3-orange?logo=swift)
![Xcode](https://img.shields.io/badge/xcode-v12.2-blue?logo=xcode)

[![GitHub Open Issues](https://img.shields.io/github/issues-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=green)](https://github.com/boostcamp-2020/Project18-B-iOS-BoostRunClub/issues)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=red)](https://github.com/boostcamp-2020/Project18-B-iOS-BoostRunClub/issues)
[![GitHub Open PR](https://img.shields.io/github/issues-pr-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=green)](https://github.com/boostcamp-2020/Project18-B-iOS-BoostRunClub/issues)
[![GitHub Closed PR](https://img.shields.io/github/issues-pr-closed-raw/boostcamp-2020/Project18-B-iOS-BoostRunClub?color=red)](https://github.com/boostcamp-2020/IProject18-B-iOS-BoostRunClub/issues)


[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

</div>

<p align="center"><br><br>🏃‍♀️🏃‍♂️🏃</p>
