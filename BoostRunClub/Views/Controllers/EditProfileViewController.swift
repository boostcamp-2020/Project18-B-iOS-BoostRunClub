//
//  EditProfileViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/09.
//

import UIKit

final class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    private lazy var navBar: UINavigationBar = makeNavigationBar()
    private lazy var navItem: UINavigationItem = makeNavigationItem()
    private lazy var imageView: UIImageView = makeImageView()
    private lazy var editLabel: UILabel = makeEditLabel()
    private lazy var nameLabel: UILabel = makeNameLabel()
    private lazy var hometownLabel: UILabel = makeHometownLabel()
    private lazy var bioLabel: UILabel = makeBioLabel()
    private lazy var firstNameTextField: UITextField = makeTextField(placeHolder: "이름")
    private lazy var lastNameTextField: UITextField = makeTextField(placeHolder: "성")
    private lazy var hometownTextField: UITextField = makeTextField(placeHolder: "시/도, 주",
                                                                    borderStyle: .roundedRect)
    private lazy var bioTextView: UITextView = makeBioTextView()
    private lazy var nameTextFieldView: UIView = makeNameTextField()
    private lazy var imagePicker = makeImagePicker()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))

    private var viewModel: EditProfileViewModelTypes?

    init(with viewModel: EditProfileViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life Cycle

extension EditProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "customBackground")
        configureLayout()
    }
}

// MARK: - Action

extension EditProfileViewController {
    @objc
    func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func didTapApplyButton() {
        viewModel?.inputs.didTapApplyButton()
    }

    @objc
    func didTapImageView(tapGestureRecognizer _: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("did tap image view")
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Configure

extension EditProfileViewController {
    func configureLayout() {
        // MARK: NavigationBar AutoLayout

        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        // MARK: ImageView AutoLayout

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
        ])

        // MARK: EditLabel AutoLayout

        view.addSubview(editLabel)
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
        ])

        // MARK: NameTextField AutoLayout

        view.addSubview(nameTextFieldView)
        nameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextFieldView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40),
            nameTextFieldView.heightAnchor.constraint(equalToConstant: 80),
            nameTextFieldView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameTextFieldView.topAnchor.constraint(equalTo: editLabel.bottomAnchor, constant: 50),
        ])

        // MARK: NameLabel AutoLayout

        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: nameTextFieldView.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: nameTextFieldView.topAnchor, constant: -5),
        ])

        // MARK: HomeTownTextField AutoLayout

        view.addSubview(hometownTextField)
        hometownTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hometownTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            hometownTextField.heightAnchor.constraint(equalToConstant: 40),
            hometownTextField.topAnchor.constraint(equalTo: nameTextFieldView.bottomAnchor, constant: 50),
            hometownTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])

        // MARK: HomeTownLabel AutoLayout

        view.addSubview(hometownLabel)
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hometownLabel.leadingAnchor.constraint(equalTo: hometownTextField.leadingAnchor),
            hometownLabel.bottomAnchor.constraint(equalTo: hometownTextField.topAnchor, constant: -5),
        ])

        // MARK: BioTextView AutoLayout

        view.addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),
            bioTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bioTextView.topAnchor.constraint(equalTo: hometownTextField.bottomAnchor, constant: 50),
        ])

        // MARK: BioLabel AutoLayout

        view.addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: bioTextView.leadingAnchor),
            bioLabel.bottomAnchor.constraint(equalTo: bioTextView.topAnchor, constant: -5),
        ])
    }

    func makeNavigationBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        navBar.barTintColor = UIColor(named: "customBackground")
        navBar.setItems([navItem], animated: false)
        return navBar
    }

    func makeNavigationItem() -> UINavigationItem {
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

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.SFSymbol(name: "person.crop.square", color: .label)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }

    func makeEditLabel() -> UILabel {
        let editLabel = EditProfileSceneLabel()
        editLabel.text = "편집"
        return editLabel
    }

    func makeNameLabel() -> UILabel {
        let nameLabel = EditProfileSceneLabel()
        nameLabel.text = "이름"
        return nameLabel
    }

    func makeNameTextField() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [lastNameTextField, firstNameTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 5
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemGray5.cgColor
        stackView.clipsToBounds = true

        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.systemGray5.cgColor

        return stackView
    }

    func makeTextField(
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

    func makeHometownLabel() -> UILabel {
        let hometownLabel = EditProfileSceneLabel()
        hometownLabel.text = "주 활동지역"
        return hometownLabel
    }

    func makeBioLabel() -> UILabel {
        let bioLabel = EditProfileSceneLabel()
        bioLabel.text = "약력"
        return bioLabel
    }

    func makeBioTextView() -> UITextView {
        let bioTextView = UITextView()
        bioTextView.delegate = self
        bioTextView.text = "150자"
        bioTextView.textColor = UIColor.lightGray
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.systemGray5.cgColor
        bioTextView.layer.cornerRadius = 5
        bioTextView.font = UIFont.systemFont(ofSize: 14)
        bioTextView.textContainerInset = UIEdgeInsets(top: 15,
                                                      left: 10,
                                                      bottom: 0,
                                                      right: 15)
        return bioTextView
    }

    func makeImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        return imagePicker
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker _: UIImagePickerController!,
                               didFinishPickingImage image: UIImage!,
                               editingInfo _: NSDictionary!)
    {
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField)
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
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
