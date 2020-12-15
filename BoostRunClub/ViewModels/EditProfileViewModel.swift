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
    // view did load view controller에서 바인딩하기
    func viewDidLoad()
    func didTapApplyButton()
    func didEditProfilePicture(to imageData: Data)
    func didEditLastName(to text: String)
    func didEditFirstName(to text: String)
    func didEditHometown(to text: String)
    func didEditBio(to text: String)
}

protocol EditProfileViewModelOutputs {
    var closeSignal: PassthroughSubject<Profile, Never> { get }
    var imageDataObservable: CurrentValueSubject<Data?, Never> { get }
    var lastNameTextObservable: CurrentValueSubject<String, Never> { get }
    var firstNameTextObservable: CurrentValueSubject<String, Never> { get }
    var hometownTextObservable: CurrentValueSubject<String, Never> { get }
    var bioTextObservable: CurrentValueSubject<String, Never> { get }
    var changeInContentSignal: PassthroughSubject<Bool, Never> { get }
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
        imageDataObservable.value = Data.loadImageDataFromDocumentsDirectory(fileName: "profile.png")
        lastNameTextObservable.value = defaults.reader.string(forKey: "LastName") ?? ""
        firstNameTextObservable.value = defaults.reader.string(forKey: "FirstName") ?? ""
        hometownTextObservable.value = defaults.reader.string(forKey: "Hometown") ?? ""
        bioTextObservable.value = defaults.reader.string(forKey: "Bio") ?? ""

        initialProfile = Profile(image: imageDataObservable.value,
                                 lastName: lastNameTextObservable.value,
                                 firstName: firstNameTextObservable.value,
                                 hometown: hometownTextObservable.value,
                                 bio: bioTextObservable.value)

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
        imageDataObservable.value = imageData
        currentProfile?.image = imageData
        compareChanges()
    }

    func didEditLastName(to text: String) {
        lastNameTextObservable.value = text
        currentProfile?.lastName = text
        compareChanges()
    }

    func didEditFirstName(to text: String) {
        firstNameTextObservable.value = text
        currentProfile?.firstName = text
        compareChanges()
    }

    func didEditHometown(to text: String) {
        hometownTextObservable.value = text
        currentProfile?.hometown = text
        compareChanges()
    }

    func didEditBio(to text: String) {
        bioTextObservable.value = text
        currentProfile?.bio = text
        compareChanges()
    }

    // ouputs

    var closeSignal = PassthroughSubject<Profile, Never>()
    var imageDataObservable = CurrentValueSubject<Data?, Never>(nil)
    var lastNameTextObservable = CurrentValueSubject<String, Never>("")
    var firstNameTextObservable = CurrentValueSubject<String, Never>("")
    var hometownTextObservable = CurrentValueSubject<String, Never>("")
    var bioTextObservable = CurrentValueSubject<String, Never>("")
    var changeInContentSignal = PassthroughSubject<Bool, Never>()
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
        changeInContentSignal.send(currentProfile != initialProfile)
    }

    private func sendChangedProfilePictureSignal() {
        if currentProfile?.image != initialProfile?.image {
            guard let image = currentProfile?.image else { return }
            // TODO: - do something here to send signal
        }
    }
}
