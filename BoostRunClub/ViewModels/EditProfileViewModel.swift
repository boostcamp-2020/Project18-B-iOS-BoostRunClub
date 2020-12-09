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

protocol EditProfileViewModelInputs {}

protocol EditProfileViewModelOutputs {
    var closeSignal: PassthroughSubject<Profile, Never> { get }
}

final class EditProfileViewModel: EditProfileViewModelInputs, EditProfileViewModelOutputs {
    // inputs

    // ouputs
    var closeSignal = PassthroughSubject<Profile, Never>()
}

extension EditProfileViewModel: EditProfileViewModelTypes {
    var inputs: EditProfileViewModelInputs { self }
    var outputs: EditProfileViewModelOutputs { self }
}
