//
//  ProfileViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/08.
//

import Combine
import Foundation

protocol ProfileViewModelTypes: AnyObject {
    var inputs: ProfileViewModelInputs { get }
    var outputs: ProfileViewModelOutputs { get }
}

protocol ProfileViewModelInputs {
    func didTapEditProfileButton()
    func didEditProfile(_ profile: Profile)
}

protocol ProfileViewModelOutputs {
    var showEditProfileSceneSignal: PassthroughSubject<Void, Never> { get }
}

class ProfileViewModel: ProfileViewModelInputs, ProfileViewModelOutputs {
    // inputs
    func didTapEditProfileButton() {
        showEditProfileSceneSignal.send()
    }

    func didEditProfile(_: Profile) {}

    // outputs
    var showEditProfileSceneSignal = PassthroughSubject<Void, Never>()

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension ProfileViewModel: ProfileViewModelTypes {
    var inputs: ProfileViewModelInputs { self }
    var outputs: ProfileViewModelOutputs { self }
}
