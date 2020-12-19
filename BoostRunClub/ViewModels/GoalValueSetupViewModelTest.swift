//
//  GoalValueSetupViewModelTest.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/11/29.
//

@testable import BoostRunClub
import Combine
import XCTest

// swiftlint:disable:next type_body_length
class GoalValueSetupViewModelTest: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testMakeViewModel_TimeType() {
        let expectedObserve = expectation(description: "setupWithTime")
        let goalInfo = GoalInfo(type: .time, value: "12:22")
        let viewModel = GoalValueSetupViewModel(
            goalType: goalInfo.type,
            goalValue: goalInfo.value
        ) // test target
        let expectedNumReceived = 1
        var numReceived = 0
        let cancellable = viewModel.goalValueSubject
            .sink { presentingValue in
                numReceived += 1
                XCTAssertEqual(presentingValue, goalInfo.value)
                if presentingValue == goalInfo.value {
                    expectedObserve.fulfill()
                }
            }

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
        XCTAssertEqual(expectedNumReceived, numReceived)
    }

    func testMakeViewModel_DistanceType() {
        let expectedObserve = expectation(description: "setupWithDistance")
        let goalInfo = GoalInfo(type: .distance, value: "25")
        let viewModel = GoalValueSetupViewModel(
            goalType: goalInfo.type,
            goalValue: goalInfo.value
        ) // test target
        let expectedNumReceived = 1
        var numReceived = 0
        let cancellable = viewModel.goalValueSubject
            .sink { presentingValue in
                numReceived += 1
                XCTAssertEqual(presentingValue, goalInfo.value)
                if presentingValue == goalInfo.value {
                    expectedObserve.fulfill()
                }
            }

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
        XCTAssertEqual(expectedNumReceived, numReceived)
    }

    func testInitialInput_TimeType() {
        let expectedObserve = expectation(description: "initialInputTime")
        let goalInfo = GoalInfo(type: .time, value: "11:11")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
        let initialInput = "1"
        let expectedValue = "00:01"

        let cancellable = viewModel.goalValueSubject
            .dropFirst()
            .sink { presentingValue in
                XCTAssertEqual(presentingValue, expectedValue)
                if presentingValue == expectedValue {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didInputNumber(initialInput) // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testInitialInput_DistanceType() {
        let expectedObserve = expectation(description: "initialInputTime")
        let goalInfo = GoalInfo(type: .distance, value: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
        let initialInput = "1"
        let expectedValue = initialInput

        let cancellable = viewModel.goalValueSubject
            .dropFirst()
            .sink { presentingValue in
                XCTAssertEqual(presentingValue, expectedValue)
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
            "1111.2.222", // 11.22
            "111111", // 11
            "111.", // 11.
            "..222", // .22
            "02.1", // 02.1
        ]
        let expectedResults = [
            "11.22",
            "11",
            "11.",
            ".22",
            "02.1",
        ]
        let expectedNumReceived = expectedResults.map { $0.count }

        inputStreams.enumerated().forEach { idx, inputs in
            let goalInfo = GoalInfo(type: .distance, value: "15.15")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)

            let expectedObserve = expectation(description: "invalidTimeInputs")
            let expectedResult = expectedResults[idx]
            let expectedNumReceived = expectedNumReceived[idx]
            var numReceived = 0
            let cancellable = viewModel.goalValueSubject
                .dropFirst()
                .sink { presentingValue in
                    numReceived += 1
                    if presentingValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            inputs.map { String($0) }.forEach { viewModel.didInputNumber($0) }
            waitForExpectations(timeout: 1, handler: nil)
            XCTAssertEqual(expectedNumReceived, numReceived)
            cancellable.cancel()
        }
    }

    func testFilterInputs_TimeType() {
        let inputStreams = [
            "11112222", // 11:11
            "00111", // 01:11
            "222", // 02:22
            "33", // 00:33
            "4", // 00:04
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
            let goalInfo = GoalInfo(type: .time, value: "")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)

            let expectedObserve = expectation(description: "invalidTimeInputs")
            let expectedResult = expectedResults[idx]
            let expectedNumReceived = expectedNumReceived[idx]
            var numReceived = 0
            let cancellable = viewModel.goalValueSubject
                .dropFirst()
                .sink { presentingValue in
                    numReceived += 1
                    if presentingValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            inputs.map { String($0) }.forEach { viewModel.didInputNumber($0) }
            waitForExpectations(timeout: 1, handler: nil)
            XCTAssertEqual(expectedNumReceived, numReceived)
            cancellable.cancel()
        }
    }

    func testDeleteBackward_DistanceType_noneInputs() {
        let expectedObserve = expectation(description: "deleteBackward_distance_noneInputs")
        let goalInfo = GoalInfo(type: .distance, value: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
        let expectedResult = "0"

        let cancellable = viewModel.goalValueSubject
            .dropFirst()
            .sink { presentingValue in
                XCTAssertEqual(presentingValue, expectedResult)
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
        let goalInfo = GoalInfo(type: .time, value: "15:15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
        let expectedResult = "00:00"

        let cancellable = viewModel.goalValueSubject
            .dropFirst()
            .sink { presentingValue in
                XCTAssertEqual(presentingValue, expectedResult)
                if presentingValue == expectedResult {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didDeleteBackward() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testDeleteBackward_DistanceType_Inputs() {
        let goalInfo = GoalInfo(type: .distance, value: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
        let cancel = ["1", "1", ".", "2", "2"].publisher
            .sink { viewModel.didInputNumber($0) }

        let expectedResults = ["11.2", "11.", "11", "1", "0", "0"]

        expectedResults.forEach { expectedResult in
            let expectedObserve = expectation(description: "deleteBackward_distance_Inputs")
            let cancellable = viewModel.goalValueSubject
                .dropFirst()
                .sink { presentingValue in
                    XCTAssertEqual(presentingValue, expectedResult)
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
        let goalInfo = GoalInfo(type: .time, value: "15:15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
        let cancel = ["1", "1", "2", "2"].publisher
            .sink { viewModel.didInputNumber($0) }

        let expectedResults = ["01:12", "00:11", "00:01", "00:00", "00:00"]

        expectedResults.forEach { expectedResult in
            let expectedObserve = expectation(description: "deleteBackward_Time_Inputs")
            let cancellable = viewModel.goalValueSubject
                .dropFirst()
                .sink { presentingValue in
                    XCTAssertEqual(presentingValue, expectedResult)
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

    func testCancelButton_DistanceType_noneInputs() {
        let expectedObserve = expectation(description: "didTapCancel_distance_noneInputs")
        let goalInfo = GoalInfo(type: .distance, value: "15.15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)

        let cancellable = viewModel.closeSignal
            .sink { resultValue in
                XCTAssertNil(resultValue)
                if resultValue == nil {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didTapCancelButton() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testCancelButton_TimeType_noneInputs() {
        let expectedObserve = expectation(description: "didTapCancel_time_noneInputs")
        let goalInfo = GoalInfo(type: .distance, value: "15:15")
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)

        let cancellable = viewModel.closeSignal
            .sink { resultValue in
                XCTAssertNil(resultValue)
                if resultValue == nil {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didTapCancelButton() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testCancelButton_DistanceType_Inputs() {
        let inputs = [
            "11.22", "1.22", ".22", ".2", ".02", "11", "1",
        ]

        let expectedResults: [String?] = [
            nil, nil, nil, nil, nil, nil, nil,
        ]

        inputs.enumerated().forEach { idx, input in
            let expectedObserve = expectation(description: "didTapCancel_distance_Inputs")

            let goalInfo = GoalInfo(type: .distance, value: "15.15")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
            input.map { String($0) }.forEach { viewModel.didInputNumber($0) }

            let expectedResult = expectedResults[idx]

            let cancel = viewModel.closeSignal
                .sink { resultValue in
                    XCTAssertEqual(resultValue, expectedResult)
                    if resultValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            viewModel.didTapCancelButton()
            waitForExpectations(timeout: 1, handler: nil)
            cancel.cancel()
        }
    }

    func testCancelButton_TimeType_Inputs() {
        let inputs = [
            "1122", "122", "22", "2", "02", "0110", "00010000",
        ]

        let expectedResults: [String?] = [
            nil, nil, nil, nil, nil, nil, nil,
        ]

        inputs.enumerated().forEach { idx, input in
            let expectedObserve = expectation(description: "didTapCancel_time_Inputs")

            let goalInfo = GoalInfo(type: .time, value: "15:15")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
            input.map { String($0) }.forEach { viewModel.didInputNumber($0) }

            let expectedResult = expectedResults[idx]

            let cancel = viewModel.closeSignal
                .sink { resultValue in
                    XCTAssertEqual(resultValue, expectedResult)
                    if resultValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            viewModel.didTapCancelButton()
            waitForExpectations(timeout: 1, handler: nil)
            cancel.cancel()
        }
    }

    func testApplyButton_DistanceType_noneInputs() {
        let expectedObserve = expectation(description: "testApplyButton_DistanceType_noneInputs")
        let initialValue = "15.15"
        let goalInfo = GoalInfo(type: .distance, value: initialValue)
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)

        let cancellable = viewModel.closeSignal
            .sink { resultValue in
                XCTAssertEqual(resultValue, initialValue)
                if resultValue == initialValue {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didTapApplyButton() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testApplyButton_TimeType_noneInputs() {
        let expectedObserve = expectation(description: "testApplyButton_TimeType_noneInputs")
        let initialValue = "15:15"
        let goalInfo = GoalInfo(type: .time, value: initialValue)
        let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)

        let cancellable = viewModel.closeSignal
            .sink { resultValue in
                XCTAssertEqual(resultValue, initialValue)
                if resultValue == initialValue {
                    expectedObserve.fulfill()
                }
            }
        viewModel.didTapApplyButton() // test target

        waitForExpectations(timeout: 1, handler: nil)
        cancellable.cancel()
    }

    func testApplyButton_DistanceType_Inputs() {
        let inputs = [
            "11.22", "1.22", ".22", ".2", ".02", "11", "1",
        ]

        let expectedResults = [
            "11.22", "1.22", "0.22", "0.20", "0.02", "11.00", "1.00",
        ]

        inputs.enumerated().forEach { idx, input in
            let expectedObserve = expectation(description: "didTapApply_distance_Inputs")

            let goalInfo = GoalInfo(type: .distance, value: "15.15")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
            input.map { String($0) }.forEach { viewModel.didInputNumber($0) }

            let expectedResult = expectedResults[idx]

            let cancel = viewModel.closeSignal
                .sink { resultValue in
                    XCTAssertEqual(resultValue, expectedResult)
                    if resultValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            viewModel.didTapApplyButton()
            waitForExpectations(timeout: 1, handler: nil)
            cancel.cancel()
        }
    }

    func testApplyButton_TimeType_Inputs() {
        let inputs = [
            "1122", "122", "22", "2", "02", "0110", "00010000",
        ]

        let expectedResults = [
            "11:22", "01:22", "00:22", "00:02", "00:02", "01:10", "10:00",
        ]

        inputs.enumerated().forEach { idx, input in
            let expectedObserve = expectation(description: "didTapApply_time_Inputs")

            let goalInfo = GoalInfo(type: .time, value: "15:15")
            let viewModel = GoalValueSetupViewModel(goalType: goalInfo.type, goalValue: goalInfo.value)
            input.map { String($0) }.forEach { viewModel.didInputNumber($0) }

            let expectedResult = expectedResults[idx]

            let cancel = viewModel.closeSignal
                .sink { resultValue in
                    XCTAssertEqual(resultValue, expectedResult)
                    if resultValue == expectedResult {
                        expectedObserve.fulfill()
                    }
                }

            viewModel.didTapApplyButton()
            waitForExpectations(timeout: 1, handler: nil)
            cancel.cancel()
        }
    }

    // swiftlint:disable:next file_length
}
