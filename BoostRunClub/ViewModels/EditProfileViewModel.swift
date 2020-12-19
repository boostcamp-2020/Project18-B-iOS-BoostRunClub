//
//  EditProfileViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/09.
//

import Combine
import Foundation

protocol EditProfileViewModelTypes {
    var inputs: EditProfileViewModelInputs { get }
    var outputs: EditProfileViewModelOutputs { get }
}

protocol EditProfileViewModelInputs {
    func didTapApplyButton()
    func didEditProfilePicture(to imageData: Data)
    func didEditLastName(to text: String)
    func didEditFirstName(to text: String)
    func didEditHometown(to text: String)
    func didEditBio(to text: String)

    // Life Cycle
    func viewDidLoad()
}

protocol EditProfileViewModelOutputs {
    // Data For Configure
    var imageDataSubject: CurrentValueSubject<Data?, Never> { get }
    var lastNameTextSubject: CurrentValueSubject<String, Never> { get }
    var firstNameTextSubject: CurrentValueSubject<String, Never> { get }
    var hometownTextSubject: CurrentValueSubject<String, Never> { get }
    var bioTextSubject: CurrentValueSubject<String, Never> { get }

    // Signal For View Action
    var saveButtonActivateSignal: PassthroughSubject<Bool, Never> { get }

    // Signal For Coordinate
    var closeSignal: PassthroughSubject<Profile, Never> { get }
}

final class EditProfileViewModel: EditProfileViewModelInputs, EditProfileViewModelOutputs {
    private var defaults: DefaultsManagable
    private var initialProfile: Profile?
    private var currentProfile: Profile?

    init(defaults: DefaultsManagable) {
        self.defaults = defaults
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // inputs

    func viewDidLoad() {
        imageDataSubject.value = Data.loadImageDataFromDocumentsDirectory(fileName: "profile.png")
        lastNameTextSubject.value = defaults.reader.string(forKey: "LastName") ?? ""
        firstNameTextSubject.value = defaults.reader.string(forKey: "FirstName") ?? ""
        hometownTextSubject.value = defaults.reader.string(forKey: "Hometown") ?? ""
        bioTextSubject.value = defaults.reader.string(forKey: "Bio") ?? ""

        initialProfile = Profile(image: imageDataSubject.value,
                                 lastName: lastNameTextSubject.value,
                                 firstName: firstNameTextSubject.value,
                                 hometown: hometownTextSubject.value,
                                 bio: bioTextSubject.value)

        currentProfile = initialProfile
    }

    func didTapApplyButton() {
        guard let currentProfile = currentProfile else { return }

        if let imageData = currentProfile.image {
            Data.saveImageDataToDocumentsDirectory(fileName: "profile.png",
                                                   imageData: imageData)
        }

        sendChangedProfilePictureSignal()
        saveProfileTextsToUserDefaults(profile: currentProfile)
        closeSignal.send(currentProfile)
    }

    func didEditProfilePicture(to imageData: Data) {
        imageDataSubject.value = imageData
        currentProfile?.image = imageData
        compareChanges()
    }

    func didEditLastName(to text: String) {
        lastNameTextSubject.value = text
        currentProfile?.lastName = text
        compareChanges()
    }

    func didEditFirstName(to text: String) {
        firstNameTextSubject.value = text
        currentProfile?.firstName = text
        compareChanges()
    }

    func didEditHometown(to text: String) {
        hometownTextSubject.value = text
        currentProfile?.hometown = text
        compareChanges()
    }

    func didEditBio(to text: String) {
        bioTextSubject.value = text
        currentProfile?.bio = text
        compareChanges()
    }

    // ouputs

    var closeSignal = PassthroughSubject<Profile, Never>()
    var imageDataSubject = CurrentValueSubject<Data?, Never>(nil)
    var lastNameTextSubject = CurrentValueSubject<String, Never>("")
    var firstNameTextSubject = CurrentValueSubject<String, Never>("")
    var hometownTextSubject = CurrentValueSubject<String, Never>("")
    var bioTextSubject = CurrentValueSubject<String, Never>("")
    var saveButtonActivateSignal = PassthroughSubject<Bool, Never>()
}

extension EditProfileViewModel: EditProfileViewModelTypes {
    var inputs: EditProfileViewModelInputs { self }
    var outputs: EditProfileViewModelOutputs { self }
}

// MARK: - Private Functions

extension EditProfileViewModel {
    private func saveProfileTextsToUserDefaults(profile: Profile) {
        defaults.writer.set(profile.firstName, forKey: "FirstName")
        defaults.writer.set(profile.lastName, forKey: "LastName")
        defaults.writer.set(profile.hometown, forKey: "Hometown")
        defaults.writer.set(profile.bio, forKey: "Bio")
    }

    private func compareChanges() {
        saveButtonActivateSignal.send(currentProfile != initialProfile)
    }

    private func sendChangedProfilePictureSignal() {
        if currentProfile?.image != initialProfile?.image {
            guard let image = currentProfile?.image else { return }
            // TODO: - do something here to send signal
        }
    }
}
