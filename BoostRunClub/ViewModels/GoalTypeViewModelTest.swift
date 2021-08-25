//
//  GoalTypeViewModelTest.swift
//  BoostRunClubTests
//
//  Created by 조기현 on 2020/11/29.
//

@testable import BoostRunClub
import Combine
import XCTest

class GoalTypeViewModelTest: XCTestCase {
    var goalTypeVM: GoalTypeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        goalTypeVM = GoalTypeViewModel(goalType: .none)
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testDidTapBackgroundView() {
        let receivedSignal = expectation(description: "received signal to close action sheet")
        let expectedGoalType: GoalType = .distance

        goalTypeVM.goalTypeSubject.send(expectedGoalType)

        let cancellable = goalTypeVM.closeSignal
            .sink {
                if $0 == expectedGoalType {
                    receivedSignal.fulfill()
                } else {
                    XCTFail("BackgroundView를 탭한 후 goalTypeVM에서 전송하는 값과 GoalType이 들어오는 값이 일치하지 않음")
                }
            }

        goalTypeVM.didTapBackgroundView()
        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testDidSelectGoalType() {
        let allCases: [GoalType] = [.distance, .speed, .time]

        allCases.forEach { goalType in
            let receivedSignal = expectation(description: "received signal that user selected goal type")

            let cancellable = Publishers.CombineLatest(
                goalTypeVM.goalTypeSubject,
                goalTypeVM.closeSignal
            )
            .sink {
                if $0 == goalType,
                   $1 == goalType
                {
                    receivedSignal.fulfill()
                } else {
                    XCTFail("GoalType 선택 후 전송하는 값과 들어오는 값이 일치하지 않음")
                }
            }

            goalTypeVM.didSelectGoalType(goalType)
            waitForExpectations(timeout: 1, handler: nil)
            cancellable.cancel()
        }
    }
}
