//
//  LoginView.swift
//  MovieReservation_4Team
//
//  Created by  on 7/22/24.
//

import UIKit
import SnapKit

class LoginView: UIViewController {

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOGO") // Logo image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        label.textColor = UIColor.mainWhite
        label.font = UIFont.systemFont(ofSize: 16)
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
        label.textColor = UIColor.mainWhite
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.mainWhite
        textField.isSecureTextEntry = true // 비밀번호를 숨기기
        return textField
    }()

    var eyeButton = UIButton(type: .custom)

    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.mainRed
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainWhite, for: .normal)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainWhite.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureUI()
        setPasswordShownButtonImage()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.mainBlack
        view.addSubview(logoImageView)
        view.addSubview(containerView)

        containerView.addSubview(idLabel)
        containerView.addSubview(idTextField)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(loginButton)
        containerView.addSubview(signupButton)
    }

    private func configureUI() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
            $0.width.equalTo(330)
        }

        containerView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(340)
        }

        idLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(24)
            $0.top.equalTo(containerView.snp.top).offset(38)
        }

        idTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalTo(containerView).inset(24)
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
        }

        passwordLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(24)
            $0.top.equalTo(idTextField.snp.bottom).offset(24)
        }

        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalTo(containerView).inset(24)
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
        }

        loginButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalTo(containerView).inset(24)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
        }

        signupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(16)
        }
    }

    private func setPasswordShownButtonImage() {
        // 이미지 버튼을 생성
        eyeButton = UIButton(type: .custom)

        // 이미지 설정
        let hiddenImage = UIImage(systemName: "eye.slash") // 비밀번호 숨김 상태 아이콘
        let shownImage = UIImage(systemName: "eye") // 비밀번호 표시 상태 아이콘

        eyeButton.setImage(hiddenImage, for: .normal)
        eyeButton.setImage(shownImage, for: .selected)

        // 버튼 액션 추가
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        // 버튼을 텍스트 필드의 오른쪽 뷰로 설정
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always

        // 버튼의 크기 조정
        eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // 크기를 적절히 설정
        eyeButton.contentMode = .scaleAspectFit
    }

    @objc private func togglePasswordVisibility() {
        // 비밀번호 가시성 전환
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }

    @objc private func signupButtonTapped() {
        self.navigationController?.pushViewController(SignUpView(), animated: true)
    }

    @objc private func loginButtonTapped() {
        // 로그인 성공 여부 확인
        let isLoginSuccessful = performLogin()

        if isLoginSuccessful {
            switchToTabBarController()
        } else {
            // 로그인 실패 시 사용자에게 알림
            showAlertForLoginFailure()
        }
    }

    private func performLogin() -> Bool {
        guard let id = idTextField.text, let password = passwordTextField.text else {
            return false
        }

        return UserDataManager.shared.loginUser(id: id, password: password)
    }

    private func switchToTabBarController() {
        // TabBarController 생성
        let tabBarController = TabBarController()

        // 현재 네비게이션 컨트롤러의 루트 뷰 컨트롤러를 TabBarController로 설정
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }

    private func showAlertForLoginFailure() {
        let alert = UIAlertController(title: "로그인 실패", message: "Please check your credentials and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        // 실패 시 회원가입으로
        alert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { _ in
            self.signupButtonTapped()
        }))
        present(alert, animated: true)
    }
}
