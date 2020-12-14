//
//  LoginCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//
//
// import UIKit
// import Combine
//
// final class LoginCoordinator: BasicCoordinator<Void> {
//    let factory: LoginSceneFactory
//
//    init(navigationController: UINavigationController, factory: LoginSceneFactory = DependencyFactory.shared) {
//        self.factory = factory
//        super.init(navigationController: navigationController)
//    }
//
//    override func start() {
//        showLoginViewController()
//    }
//
//    func showLoginViewController() -> AnyPublisher<Void, Never> {
//        let loginVC = LoginViewController()
//        navigationController.pushViewController(loginVC, animated: true)
//    }
// }
