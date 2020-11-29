//
//  GoalValueSetupViewModelTest.swift
//  BoostRunClubTests
//
//  Created by 조기현 on 2020/11/29.
//

@testable import BoostRunClub
import Combine
import XCTest

class GoalValueSetupViewModelTest: XCTestCase {
    /*
     protocol GoalValueSetupViewModelInputs {
         func didDeleteBackward()
         func didInputNumber(_ number: String)
         func didTapCancelButton()
         func didTapApplyButton()
     }

     protocol GoalValueSetupViewModelOutputs {
         var goalValueObservable: CurrentValueSubject<String, Never> { get }
         var runningEstimationObservable: AnyPublisher<String, Never> { get }
         var closeSheetSignal: PassthroughSubject<String?, Never> { get }
         var goalType: GoalType { get }
     }
     */

    override func setUp() {}

    override func tearDown() {}

    func testMakeViewModel_TimeType() {
        let expectedObserve = expectation(description: "setupWithTime")
        let goalInfo = GoalInfo(goalType: .time, goalValue: "12:22")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue) // test target
        let cancellable = viewModel.goalValueObservable
            .first()
            .sink { presentingValue in
                if presentingValue == goalInfo.goalValue {
                    expectedObserve.fulfill()
                }
            }

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testMakeViewModel_DistanceType() {
        let expectedObserve = expectation(description: "setupWithDistance")
        let goalInfo = GoalInfo(goalType: .distance, goalValue: "25")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue) // test target
        let cancellable = viewModel.goalValueObservable
            .first()
            .sink { presentingValue in
                if presentingValue == goalInfo.goalValue {
                    expectedObserve.fulfill()
                }
            }

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testInitialInput_TimeType() {
        let expectedObserve = expectation(description: "initialInputTime")
        let goalInfo = GoalInfo(goalType: .time, goalValue: "11:11")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
        let initialInput = "1"

        let cancellable = viewModel.goalValueObservable
            .dropFirst()
            .sink { presentingValue in
                if presentingValue == "00:01" {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didInputNumber(initialInput) // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testInitialInput_DistanceType() {
        let expectedObserve = expectation(description: "initialInputTime")
        let goalInfo = GoalInfo(goalType: .distance, goalValue: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
        let initialInput = "1"

        let cancellable = viewModel.goalValueObservable
            .dropFirst()
            .sink { presentingValue in
                if presentingValue == initialInput {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didInputNumber(initialInput) // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testFilterInputs_DistanceType() {
        let inputStreams = [
            ["1", "1", "1", "1", ".", "2", ".", "2", "2", "2"], // 11.22
            ["1", "1", "1", "1", "1", "1"], // 11
            ["1", "1", "1", "."], // 11.
            [".", ".", "2", "2", "2"], // .22
            ["0", "2", ".", "1"], // 02.1
        ]
        let expectedResults = [
            "11.22",
            "11",
            "11.",
            ".22",
            "02.1",
        ]

        inputStreams.enumerated().forEach { idx, inputs in
            let goalInfo = GoalInfo(goalType: .distance, goalValue: "15.15")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)

            let expectedObserve = expectation(description: "invalidDistanceInputs")
            let expectedResult = expectedResults[idx]
            let expectedNumReceived = expectedResults[idx].count
            var numReceived = 0
            let cancellable = viewModel.goalValueObservable
                .dropFirst()
                .sink { presentingValue in
                    numReceived += 1
                    if presentingValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            let cancellable2 = inputs.publisher.sink { viewModel.didInputNumber($0) } // test target
            waitForExpectations(timeout: 1, handler: nil)
            XCTAssertEqual(expectedNumReceived, numReceived)
            cancellable.cancel()
            cancellable2.cancel()
        }
    }

    func testFilterInputs_TimeType() {
        let inputStreams = [
            ["1", "1", "1", "1", "2", "2", "2", "2"], // 11:11
            ["0", "0", "1", "1", "1"], // 01:11
            ["2", "2", "2"], // 02:22
            ["3", "3"], // 00:33
            ["4"], // 00:04
        ]
        let expectedResults = [
            "11:11",
            "01:11",
            "02:22",
            "00:33",
            "00:04",
        ]
        let expectedNumReceived = [4, 3, 3, 2, 1]

        inputStreams.enumerated().forEach { idx, inputs in
            let goalInfo = GoalInfo(goalType: .time, goalValue: "")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)

            let expectedObserve = expectation(description: "invalidTimeInputs")
            let expectedResult = expectedResults[idx]
            let expectedNumReceived = expectedNumReceived[idx]
            var numReceived = 0
            let cancellable = viewModel.goalValueObservable
                .dropFirst()
                .sink { presentingValue in
                    numReceived += 1
                    if presentingValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            let cancellable2 = inputs.publisher.sink { viewModel.didInputNumber($0) }  // test target
            waitForExpectations(timeout: 1, handler: nil)
            XCTAssertEqual(expectedNumReceived, numReceived)
            cancellable.cancel()
            cancellable2.cancel()
        }
    }

    func testDeleteBackward_DistanceType_noneInputs() {
        let expectedObserve = expectation(description: "deleteBackward_distance_noneInputs")
        let goalInfo = GoalInfo(goalType: .distance, goalValue: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
        let expectedResult = "0"

        let cancellable = viewModel.goalValueObservable
            .sink { presentingValue in
                if presentingValue == expectedResult {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didDeleteBackward() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testDeleteBackward_TimeType_noneInputs() {
        let expectedObserve = expectation(description: "deleteBackward_time_noneInputs")
        let goalInfo = GoalInfo(goalType: .time, goalValue: "15:15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
        let expectedResult = "00:00"

        let cancellable = viewModel.goalValueObservable
            .sink { presentingValue in
                if presentingValue == expectedResult {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didDeleteBackward() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testDeleteBackward_DistanceType_Inputs() {
        let goalInfo = GoalInfo(goalType: .distance, goalValue: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
        let cancel = ["1", "1", ".", "2", "2"].publisher
            .sink { viewModel.didInputNumber($0) }

        let expectedResults = ["11.2", "11.", "11", "1", "0", "0"]

        expectedResults.forEach { expectedResult in
            let expectedObserve = expectation(description: "deleteBackward_distance_Inputs")
            let cancellable = viewModel.goalValueObservable
                .dropFirst()
                .sink { presentingValue in
                    if expectedResult == presentingValue {
                        expectedObserve.fulfill()
                    }
                }
            viewModel.didDeleteBackward() // test target
            waitForExpectations(timeout: 1, handler: nil)
            cancellable.cancel()
        }
        cancel.cancel()
    }

    func testDeleteBackward_TimeType_Inputs() {
        let goalInfo = GoalInfo(goalType: .time, goalValue: "15:15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
        let cancel = ["1", "1", "2", "2"].publisher
            .sink { viewModel.didInputNumber($0) }

        let expectedResults = ["01:12", "00:11", "00:01", "00:00", "00:00"]

        expectedResults.forEach { expectedResult in
            let expectedObserve = expectation(description: "deleteBackward_distance_Inputs")
            let cancellable = viewModel.goalValueObservable
                .dropFirst()
                .sink { presentingValue in
                    if expectedResult == presentingValue {
                        expectedObserve.fulfill()
                    }
                }
            viewModel.didDeleteBackward() // test target
            waitForExpectations(timeout: 1, handler: nil)
            cancellable.cancel()
        }
        cancel.cancel()
    }
    
    
}
