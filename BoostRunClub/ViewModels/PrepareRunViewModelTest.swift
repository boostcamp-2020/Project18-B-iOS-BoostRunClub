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

     //func didTapShowProfileButton()
    /*
     func didTapSetGoalButton() *
     func didTapStartButton()
     func didChangeGoalType(_ goalType: GoalType)
     func didChangeGoalValue(_ goalValue: String?)
     func didTapGoalValueButton()
     */

    override func setUp() {
        prepareVM = PrepareRunViewModel(locationProvider: LocationProviderMock())
        cancellables = []
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
    
}
