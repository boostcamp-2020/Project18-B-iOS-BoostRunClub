//
//  PrepareRunViewModelTest.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/11/28.
//

@testable import BoostRunClub
import Combine
import XCTest

class PrepareRunViewModelTest: XCTestCase {
    var prepareVM: PrepareRunViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        prepareVM = PrepareRunViewModel(locationProvider: LocationProviderMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    // input -> output
    func testShowGoalTypeActionSheet_GoalTypeButtonTapped() {
        let allCases: [GoalType] = [.distance, .none, .speed, .time]
        var results = [GoalType]()

        allCases.forEach { goalType in
            let receivedSignal = expectation(description: "receivedSignal")
            prepareVM.goalTypeObservable.send(goalType)
            let cancellable = prepareVM.showGoalTypeActionSheetSignal
                .sink {
                    results.append($0)
                    if $0 == goalType {
                        receivedSignal.fulfill()
                    } else {
                        XCTFail("ActionSheet에 전달되는 GoalType(\($0))이 현재 설정된 GoalType(\(goalType))과 다름")
                    }
                }

            prepareVM.didTapSetGoalButton()
            waitForExpectations(timeout: 1, handler: nil)
            cancellable.cancel()
        }

        XCTAssertEqual(allCases, results)
    }

    func testDidChangeGoalType_allCasesExceptNone() {
        let allCases: [GoalType] = [.distance, .speed, .time]
        var results = [GoalInfo]()

        allCases.forEach { goalType in
            let receivedSignal = expectation(description: "received correct goal type 장임호가 쓴 테스트")

            prepareVM.goalTypeObservable.send(.none)
            let cancellable = Publishers.CombineLatest3(
                prepareVM.goalTypeObservable,
                prepareVM.goalValueObservable,
                prepareVM.goalTypeSetupClosed
            )
            .sink {
                print($0)
                if $0.0 == goalType,
                   $0.1 == goalType.initialValue
                {
                    results.append(GoalInfo(goalType: $0.0, goalValue: $0.1))
                    receivedSignal.fulfill()
                }
            }
            prepareVM.didChangeGoalType(goalType)
            waitForExpectations(timeout: 1, handler: nil)
            cancellable.cancel()
        }

        XCTAssertEqual(allCases.count, results.count)
        allCases.enumerated().forEach { index, goalType in
            XCTAssertEqual(GoalInfo(goalType: goalType, goalValue: goalType.initialValue), results[index])
        }
    }

    func testDidChangeGoalType_noneCase() {
        let goalType = GoalType.none
        prepareVM.goalTypeObservable.send(.distance)
        let receivedSignal = expectation(description: "received correct goal type(.none)")
        let cancellable = prepareVM.goalTypeObservable.zip(prepareVM.goalValueObservable).dropFirst()
            .sink {
                if $0.0 == goalType,
                   $0.1 == goalType.initialValue
                {
                    receivedSignal.fulfill()
                }
            }
        prepareVM.didChangeGoalType(goalType)
        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testDidChangeGoalValue_input_nil() {
        let goalValue: String? = nil
        let receivedSignal = expectation(description: "")

        prepareVM.goalValueSetupClosed.sink { _ in
            receivedSignal.fulfill()
        }.store(in: &cancellables)

        prepareVM.goalValueObservable.dropFirst().sink {
            print($0)
            XCTFail()
        }.store(in: &cancellables)

        prepareVM.didChangeGoalValue(goalValue)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDidChangeGoalValue_input_non_nil() {
        let goalValue = "Goal Value"
        let receivedSignal = expectation(description: "")

        prepareVM.goalValueObservable.send(goalValue)
        prepareVM.goalValueObservable.dropFirst()
            .sink {
                if $0 == goalValue {
                    receivedSignal.fulfill()
                }
            }.store(in: &cancellables)
        prepareVM.didChangeGoalValue(goalValue)
        waitForExpectations(timeout: 1, handler: nil)
    }
}

// func didTapShowProfileButton()
/*
 func didTapSetGoalButton() *
 func didTapStartButton() *
 func didChangeGoalType(_ goalType: GoalType) *
 func didChangeGoalValue(_ goalValue: String?)
 func didTapGoalValueButton()
 */
