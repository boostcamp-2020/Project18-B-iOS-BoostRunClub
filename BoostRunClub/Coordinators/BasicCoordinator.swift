//
//  BasicCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import UIKit

class BasicCoordinator<ResultType>: Coordinator {
    typealias CoordinationResult = ResultType

    let identifier = UUID()
    var navigationController: UINavigationController

    var childCoordinators = [UUID: Coordinator]()
    var closeSubscription = [UUID: AnyCancellable]()

    var closeSignal = PassthroughSubject<CoordinationResult, Never>()

    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
        print("[Memory \(Date())] 🌈Coordinator🌈 \(Self.self) started")
    }

    private func store<T>(coordinator: BasicCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    @discardableResult
    func coordinate<T>(coordinator: BasicCoordinator<T>) -> AnyPublisher<T, Never> {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start()
        return coordinator.closeSignal.eraseToAnyPublisher()
    }

    func release<T>(coordinator: BasicCoordinator<T>) {
        let uuid = coordinator.identifier
        childCoordinators[uuid] = nil
        closeSubscription[uuid]?.cancel()
        closeSubscription.removeValue(forKey: uuid)
    }

    func start() {
        fatalError("start() method must be implemented")
    }

    deinit {
        print("[Memory \(Date())] 🌈Coordinator💀 \(Self.self) deallocated.")
    }
}
