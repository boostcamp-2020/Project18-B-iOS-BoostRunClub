//
//  EditProfileViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/09.
//

import Combine
import UIKit

final class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    private var layers = [CALayer]()
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var navBar: UINavigationBar = makeNavigationBar()
    private lazy var navItem: UINavigationItem = makeNavigationItem()
    private lazy var imageView: UIImageView = makeImageView()
    private lazy var editLabel: UILabel = makeLabel(withText: "편집", gestureRecognizer: editLabelGestureRecognizer)
    private lazy var nameLabel: UILabel = makeLabel(withText: "이름")
    private lazy var hometownLabel: UILabel = makeLabel(withText: "주 활동지역")
    private lazy var bioLabel: UILabel = makeLabel(withText: "약력")
    private lazy var imagePicker = makeImagePicker()
    private lazy var bioTextView: UITextView = makeBioTextView()
    private lazy var nameTextFieldView: UIStackView = makeNameTextField()
    private lazy var firstNameTextField: UITextField = makeTextField(placeHolder: "이름")
    private lazy var lastNameTextField: UITextField = makeTextField(placeHolder: "성")
    private lazy var hometownTextField: UITextField = makeTextField(placeHolder: "시/도, 주",
                                                                    borderStyle: .roundedRect)
    private lazy var imageViewGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                         action: #selector(didTapOpenImagePicker))
    private lazy var editLabelGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                         action: #selector(didTapOpenImagePicker))

    private var viewModel: EditProfileViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: EditProfileViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    // TODO: Editprofile viewmodel input의 view did laod 함수 바인딩하기. 아래 바인딩 함수는 뭐하는 녀석인지 판단후 다시 정리하기
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.firstNameTextSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.firstNameTextField.text = text
            }
            .store(in: &cancellables)

        viewModel.outputs.lastNameTextSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.lastNameTextField.text = text
            }
            .store(in: &cancellables)

        viewModel.outputs.hometownTextSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.hometownTextField.text = text
            }
            .store(in: &cancellables)

        viewModel.outputs.bioTextSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.bioTextView.text = text
                if !text.isEmpty { self?.bioTextView.textColor = .label }
            }
            .store(in: &cancellables)

        viewModel.outputs.imageDataSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                if let imageData = imageData {
                    self?.imageView.image = UIImage(data: imageData)
                } else {
                    self?.imageView.image = UIImage.SFSymbol(name: "person.circle", color: .gray)
                }
            }
            .store(in: &cancellables)

        viewModel.outputs.saveButtonActivateSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] (bool: Bool) in
                if bool {
                    self?.navItem.rightBarButtonItem?.tintColor = .label
                    self?.navItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self?.navItem.rightBarButtonItem?.tintColor = .gray
                    self?.navItem.rightBarButtonItem?.isEnabled = false
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Life Cycle

extension EditProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "customBackground")
        imagePicker.delegate = self
        configureLayout()
        bindViewModel()
        viewModel?.inputs.viewDidLoad()
        registerKeyboardNotifications()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layers.forEach { $0.borderColor = UIColor.systemGray5.cgColor }
    }
}

// MARK: - Action

extension EditProfileViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame: CGRect = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
        else { return }

        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    @objc
    private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func didTapApplyButton() {
        viewModel?.inputs.didTapApplyButton()
    }

    @objc
    private func didTapOpenImagePicker(_: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Private Functions

extension EditProfileViewController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Make Views

extension EditProfileViewController {
    private func makeNavigationBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        navBar.barTintColor = UIColor(named: "customBackground")
        navBar.setItems([navItem], animated: false)
        return navBar
    }

    private func makeNavigationItem() -> UINavigationItem {
        let navItem = UINavigationItem()
        navItem.hidesBackButton = true

        let cancelItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        cancelItem.tintColor = .label
        navItem.setLeftBarButton(cancelItem, animated: true)

        let applyItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(didTapApplyButton)
        )
        applyItem.tintColor = .systemGray2
        navItem.setRightBarButton(applyItem, animated: true)

        return navItem
    }

    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size = CGSize(width: 80, height: 80)
        imageView.image = UIImage.SFSymbol(name: "person.circle", color: .gray)
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(imageViewGestureRecognizer)
        return imageView
    }

    private func makeLabel(withText text: String, gestureRecognizer: UIGestureRecognizer? = nil) -> UILabel {
        let label = EditProfileSceneLabel()
        label.text = text
        if let gestureRecognizer = gestureRecognizer {
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(gestureRecognizer)
        }
        return label
    }

    private func makeNameTextField() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [lastNameTextField, firstNameTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 5
        stackView.layer.borderWidth = 1

        stackView.layer.borderColor = UIColor.systemGray5.cgColor
        layers.append(stackView.layer)
        stackView.clipsToBounds = true

        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.systemGray5.cgColor
        layers.append(lastNameTextField.layer)
        return stackView
    }

    private func makeTextField(
        placeHolder: String,
        borderStyle: UITextField.BorderStyle = .none
    )
        -> UITextField
    {
        let textField = CustomPaddedTextField()
        textField.delegate = self
        textField.placeholder = placeHolder
        textField.borderStyle = borderStyle
        return textField
    }

    private func makeBioTextView() -> UITextView {
        let bioTextView = UITextView()
        bioTextView.delegate = self
        bioTextView.text = "150자"
        bioTextView.textColor = UIColor.lightGray
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.systemGray5.cgColor
        layers.append(bioTextView.layer)
        bioTextView.layer.cornerRadius = 5
        bioTextView.font = UIFont.systemFont(ofSize: 14)
        bioTextView.textContainerInset = UIEdgeInsets(top: 15,
                                                      left: 10,
                                                      bottom: 0,
                                                      right: 15)
        return bioTextView
    }

    private func makeImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        return imagePicker
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("error while retrieving image info")
        }

        imageView.image = selectedImage
        guard let imageData = selectedImage.pngData() else {
            fatalError("error while encoding image to png data")
        }
        viewModel?.inputs.didEditProfilePicture(to: imageData)
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case lastNameTextField:
            viewModel?.inputs.didEditLastName(to: textField.text ?? "")
        case firstNameTextField:
            viewModel?.inputs.didEditFirstName(to: textField.text ?? "")
        case hometownTextField:
            viewModel?.inputs.didEditHometown(to: textField.text ?? "")
        default:
            return
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case lastNameTextField:
            viewModel?.inputs.didEditLastName(to: textField.text ?? "")
        case firstNameTextField:
            viewModel?.inputs.didEditFirstName(to: textField.text ?? "")
        case hometownTextField:
            viewModel?.inputs.didEditHometown(to: textField.text ?? "")
        default:
            return
        }
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "150자"
            textView.textColor = UIColor.lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel?.inputs.didEditBio(to: textView.text ?? "")
        if !textView.text.isEmpty {
            textView.textColor = UIColor.black
        }
    }
}

// MARK: - Configure

extension EditProfileViewController {
    // swiftlint:disable:next function_body_length
    private func configureLayout() {
        // MARK: ScrollView AutoLayout

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // MARK: ContentView AutoLayout

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        // MARK: NavigationBar AutoLayout

        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: scrollView.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])

        // MARK: ImageView AutoLayout

        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
        ])

        // MARK: EditLabel AutoLayout

        contentView.addSubview(editLabel)
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            editLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
        ])

        // MARK: NameTextField AutoLayout

        contentView.addSubview(nameTextFieldView)
        nameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextFieldView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
            nameTextFieldView.heightAnchor.constraint(equalToConstant: 80),
            nameTextFieldView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextFieldView.topAnchor.constraint(equalTo: editLabel.bottomAnchor, constant: 50),
        ])

        // MARK: NameLabel AutoLayout

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: nameTextFieldView.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: nameTextFieldView.topAnchor, constant: -5),
        ])

        // MARK: HomeTownTextField AutoLayout

        contentView.addSubview(hometownTextField)
        hometownTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hometownTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            hometownTextField.heightAnchor.constraint(equalToConstant: 40),
            hometownTextField.topAnchor.constraint(equalTo: nameTextFieldView.bottomAnchor, constant: 50),
            hometownTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])

        // MARK: HomeTownLabel AutoLayout

        contentView.addSubview(hometownLabel)
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hometownLabel.leadingAnchor.constraint(equalTo: hometownTextField.leadingAnchor),
            hometownLabel.bottomAnchor.constraint(equalTo: hometownTextField.topAnchor, constant: -5),
        ])

        // MARK: BioTextView AutoLayout

        contentView.addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),
            bioTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bioTextView.topAnchor.constraint(equalTo: hometownTextField.bottomAnchor, constant: 50),
            bioTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        // MARK: BioLabel AutoLayout

        contentView.addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: bioTextView.leadingAnchor),
            bioLabel.bottomAnchor.constraint(equalTo: bioTextView.topAnchor, constant: -5),
        ])
    }
}

class EditProfileSceneLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 12)
        textColor = .systemGray
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CustomPaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0,
                               left: 15,
                               bottom: 0,
                               right: 15)

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 14)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
