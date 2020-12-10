//
//  EditProfileViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/09.
//

import Combine

protocol EditProfileViewModelTypes {
    var inputs: EditProfileViewModelInputs { get }
    var outputs: EditProfileViewModelOutputs { get }
}

protocol EditProfileViewModelInputs {
    func didTapApplyButton()
    func didEditProfilePicture(to image: String)
    func didEditLastName(to text: String)
    func didEditFirstName(to text: String)
    func didEditHometown(to text: String)
    func didEditBio(to text: String)
}

protocol EditProfileViewModelOutputs {
    var closeSignal: PassthroughSubject<Profile, Never> { get }
}

final class EditProfileViewModel: EditProfileViewModelInputs, EditProfileViewModelOutputs {
    // inputs
    var lastName: String = ""
    var firstName: String = ""
    var hometown: String = ""
    var bio: String = ""

    func didTapApplyButton() {
        print("did tap apply")
        // create profile struct and send it inside close signal
        let profile = Profile(image: nil,
                              lastName: lastName,
                              firstName: firstName,
                              hometown: hometown,
                              bio: bio)
        print(profile)
        closeSignal.send(profile)
    }

    func didEditProfilePicture(to _: String) {}

    func didEditLastName(to text: String) {
        lastName = text
    }

    func didEditFirstName(to text: String) {
        firstName = text
    }

    func didEditHometown(to text: String) {
        hometown = text
    }

    func didEditBio(to text: String) {
        bio = text
    }

    // ouputs
    var closeSignal = PassthroughSubject<Profile, Never>()
}

extension EditProfileViewModel: EditProfileViewModelTypes {
    var inputs: EditProfileViewModelInputs { self }
    var outputs: EditProfileViewModelOutputs { self }
}
