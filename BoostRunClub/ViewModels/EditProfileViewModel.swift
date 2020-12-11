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
}

final class EditProfileViewModel: EditProfileViewModelInputs, EditProfileViewModelOutputs {
    private var defaults: DefaultsManagable

    init(defaults: DefaultsManagable) {
        self.defaults = defaults
    }

    // inputs

    func viewDidLoad() {
        imageDataObservable.value = Data.loadImageDataFromDocumentsDirectory(fileName: "profile.png")
        lastNameTextObservable.value = defaults.reader.string(forKey: "LastName") ?? ""
        firstNameTextObservable.value = defaults.reader.string(forKey: "FirstName") ?? ""
        hometownTextObservable.value = defaults.reader.string(forKey: "Hometown") ?? ""
        bioTextObservable.value = defaults.reader.string(forKey: "Bio") ?? ""
    }

    func didTapApplyButton() {
        let profile = Profile(image: imageDataObservable.value,
                              lastName: lastNameTextObservable.value,
                              firstName: firstNameTextObservable.value,
                              hometown: hometownTextObservable.value,
                              bio: bioTextObservable.value)

        if let imageData = profile.image {
            Data.saveImageDataToDocumentsDirectory(fileName: "profile.png",
                                                   imageData: imageData)
        }
        saveProfileTextsToUserDefaults(profile: profile)
        closeSignal.send(profile)
    }

    func didEditProfilePicture(to imageData: Data) {
        imageDataObservable.value = imageData
    }

    func didEditLastName(to text: String) {
        lastNameTextObservable.value = text
    }

    func didEditFirstName(to text: String) {
        firstNameTextObservable.value = text
    }

    func didEditHometown(to text: String) {
        hometownTextObservable.value = text
    }

    func didEditBio(to text: String) {
        bioTextObservable.value = text
    }

    // ouputs

    var closeSignal = PassthroughSubject<Profile, Never>()
    lazy var imageDataObservable = CurrentValueSubject<Data?, Never>(nil)
    lazy var lastNameTextObservable = CurrentValueSubject<String, Never>("")
    lazy var firstNameTextObservable = CurrentValueSubject<String, Never>("")
    lazy var hometownTextObservable = CurrentValueSubject<String, Never>("")
    lazy var bioTextObservable = CurrentValueSubject<String, Never>("")

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
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
}
