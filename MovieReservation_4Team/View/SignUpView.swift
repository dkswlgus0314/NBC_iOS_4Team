import UIKit
import SnapKit

class SignUpView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {


    var isUpdating: Bool = false

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 70
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var changeProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 변경", for: .normal)
        button.titleLabel?.font = FontNames.mainFont.font()
        button.setTitleColor(UIColor.mainRed, for: .normal)
        button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return button
    }()

    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        label.textColor = .white
        label.font = FontNames.subFont2.font()
        return label
    }()

    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디를 입력하세요"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.mainWhite
        return textField
    }()

    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .white
        label.font = FontNames.subFont2.font()
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.mainWhite
        return textField
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.font = FontNames.subFont2.font()
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.mainWhite
        return textField
    }()

    let hpLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.textColor = .white
        label.font = FontNames.subFont2.font()
        return label
    }()

    let hpTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "010 - 0000 - 0000"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.mainWhite
        return textField
    }()

    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.mainRed
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hpTextField.delegate = self // Add this line to set the delegate for hpTextField
        if isUpdating {
            fetchUserData() // Load user data if updating
        }
    }

    private func configureUI() {
        view.backgroundColor = UIColor.mainBlack

        [
            profileImageView,
            changeProfileButton,
            idLabel,
            idTextField,
            passwordLabel,
            passwordTextField,
            nameLabel,
            nameTextField,
            hpLabel,
            hpTextField,
            signUpButton
        ].forEach { view.addSubview($0) }

        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }

        changeProfileButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
        }

        idLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(changeProfileButton.snp.bottom).offset(8)
        }

        idTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(idLabel.snp.bottom).offset(2)
        }

        passwordLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(idTextField.snp.bottom).offset(8)
        }

        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(passwordLabel.snp.bottom).offset(2)
        }

        nameLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
        }

        nameTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        hpLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(nameTextField.snp.bottom).offset(8)
        }
        hpTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(hpLabel.snp.bottom).offset(2)
        }

        signUpButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(hpTextField.snp.bottom).offset(32)
        }

        signUpButton.setTitle(isUpdating ? "Update" : "Sign Up", for: .normal)
    }

    @objc private func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    @objc private func signupButtonTapped() {
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let phone = hpTextField.text, !phone.isEmpty else {
            showAlertForLoginFailure(message: "모든 필드를 작성해주세요.")
            return
        }

        let userProfileImageData = profileImageView.image?.pngData()

        if isUpdating {
            // Update existing user
            if let user = UserDataManager.shared.getCurrentLoggedInUser() {
                UserDataManager.shared.updateUser(id: user.id ?? "", name: name, phone: phone, password: password, userprofile: userProfileImageData)

                // Post notification for user data update
                NotificationCenter.default.post(name: NSNotification.Name("UserDataUpdated"), object: nil)

                // Navigate back to MyPageController after update
                navigationController?.popViewController(animated: true)
            } else {
                showAlertForLoginFailure(message: "로그인된 사용자 정보가 없습니다.")
            }
        } else {
            // Save new user
            UserDataManager.shared.saveUser(name: name, phone: phone, id: id, password: password, userprofile: userProfileImageData)

            // Post notification for user data update
            NotificationCenter.default.post(name: NSNotification.Name("UserDataUpdated"), object: nil)

            // Navigate back to MyPageController after sign up
            navigationController?.popViewController(animated: true)
        }
    }


    private func showAlertForLoginFailure(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    private func fetchUserData() {
        // 현재 로그인된 사용자 정보를 가져옵니다.
        if let user = UserDataManager.shared.getCurrentLoggedInUser() {
            // 사용자 정보를 UI에 업데이트합니다.
            idTextField.text = user.id
            nameTextField.text = user.name
            passwordTextField.text = user.password
            hpTextField.text = user.phone
            if let imageData = user.userprofile {
                profileImageView.image = UIImage(data: imageData)
            }
        } else {
            // 로그인된 사용자가 없을 때 알림을 표시합니다.
            showAlertForLoginFailure(message: "로그인된 사용자 정보가 없습니다.")
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == hpTextField {
               guard let text = textField.text else { return true }
               let newString = (text as NSString).replacingCharacters(in: range, with: string)
               textField.text = formatPhoneNumber(newString)
               return false
           }
           return true
       }

       private func formatPhoneNumber(_ phoneNumber: String) -> String {
           let digits = phoneNumber.filter { $0.isNumber }
           var result = ""
           for (index, digit) in digits.enumerated() {
               if index == 3 || index == 7 {
                   result.append("-")
               }
               result.append(digit)
           }
           return result
       }
}

