//
//  ProfileViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/08.
//

import Combine
import Foundation
import UIKit

protocol ProfileViewModelTypes: AnyObject {
    var inputs: ProfileViewModelInputs { get }
    var outputs: ProfileViewModelOutputs { get }
}

protocol ProfileViewModelInputs {
    func viewDidLoad()
    func didTapEditProfileButton()
    func didEditProfile(_ profile: Profile)
}

protocol ProfileViewModelOutputs {
    var showEditProfileSceneSignal: PassthroughSubject<Void, Never> { get }
    var profileSignal: PassthroughSubject<Profile, Never> { get }
}

final class ProfileViewModel: ProfileViewModelInputs, ProfileViewModelOutputs {
    private var defaults: DefaultsReadable
    private var profile: Profile

    init(defaults: DefaultsReadable) {
        self.defaults = defaults
        profile = Profile(image: Data.loadImageDataFromDocumentsDirectory(fileName: "profile.png"),
                          lastName: defaults.string(forKey: "LastName") ?? "",
                          firstName: defaults.string(forKey: "FirstName") ?? "",
                          hometown: defaults.string(forKey: "Hometown") ?? "",
                          bio: defaults.string(forKey: "Bio") ?? "")
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // inputs

    func viewDidLoad() {
        profileSignal.send(profile)
    }

    func didTapEditProfileButton() {
        showEditProfileSceneSignal.send()
    }

    func didEditProfile(_ profile: Profile) {
        profileSignal.send(profile)
    }

    // outputs

    var showEditProfileSceneSignal = PassthroughSubject<Void, Never>()
    var profileSignal = PassthroughSubject<Profile, Never>()
}

extension ProfileViewModel: ProfileViewModelTypes {
    var inputs: ProfileViewModelInputs { self }
    var outputs: ProfileViewModelOutputs { self }
}
