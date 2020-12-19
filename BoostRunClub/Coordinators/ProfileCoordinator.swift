//
//  ProfileCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

final class ProfileCoordinator: BasicCoordinator<Void> {
    let factory: ProfileSceneFactory & EditProfileSceneFactory

    init(navigationController: UINavigationController,
         factory: ProfileSceneFactory & EditProfileSceneFactory = DependencyFactory.shared)
    {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showProfileViewController()
    }

    func showProfileViewController() {
        let profileVM = factory.makeProfileVM()
        profileVM.outputs.showEditProfileSignal
            .receive(on: RunLoop.main)
            .compactMap { [weak self] in self?.showEditProfileScene() }
            .flatMap { $0 }
            .sink { [weak profileVM] (profile: Profile) in
                profileVM?.inputs.didEditProfile(profile)
            }
            .store(in: &cancellables)

        let profileVC = factory.makeProfileVC(with: profileVM)
        navigationController.pushViewController(profileVC, animated: true)
    }

    func showEditProfileScene() -> AnyPublisher<Profile, Never> {
        let editProfileVM = factory.makeEditProfileVM()
        let editProfileVC = factory.makeEditProfileVC(with: editProfileVM)

        editProfileVC.modalPresentationStyle = .overFullScreen
        navigationController.present(editProfileVC, animated: true, completion: nil)

        return editProfileVM.outputs.closeSignal
            .receive(on: RunLoop.main)
            .map { [weak editProfileVC] (profile: Profile) -> Profile in
                editProfileVC?.dismiss(animated: true, completion: nil)
                return profile
            }
            .eraseToAnyPublisher()
    }
}
