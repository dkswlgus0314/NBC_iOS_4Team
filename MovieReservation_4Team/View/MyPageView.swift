import UIKit
import SnapKit

class MyPageView: UIView {

    var onEditInfoSelected: (() -> Void)?

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 정보"
        label.textColor = UIColor.mainWhite
        label.font = FontNames.mainFont3.font()
        return label
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.backgroundColor = .white
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 이름"
        label.textColor = UIColor.mainWhite
        label.font = FontNames.mainFont.font()
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false // 스크롤 비활성화
        tableView.backgroundColor = UIColor.mainBlack
        return tableView
    }()

    private let logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "LOGO")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        fetchUserData()

        // 사용자의 업데이트 데이터 알람
        NotificationCenter.default.addObserver(self, selector: #selector(userDataUpdated), name: NSNotification.Name("UserDataUpdated"), object: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        fetchUserData()

        // 업데이트 데이터 알람
        NotificationCenter.default.addObserver(self, selector: #selector(userDataUpdated), name: NSNotification.Name("UserDataUpdated"), object: nil)
    }

    @objc private func userDataUpdated() {
        fetchUserData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UserDataUpdated"), object: nil)
    }

    private func setupViews() {
        [
            informationLabel,
            profileImageView,
            nameLabel,
            tableView,
            logoImage
        ].forEach { self.addSubview($0) }

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        informationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
        }

        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(informationLabel.snp.bottom).offset(50)
            $0.width.height.equalTo(160)
        }

        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(240) // 각 셀의 높이를 60으로 설정
        }

        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tableView.snp.bottom).offset(10)
            $0.width.equalTo(200)
        }
    }

    private func fetchUserData() {
        if let user = UserDataManager.shared.getCurrentLoggedInUser() {
            nameLabel.text = user.name
            if let imageData = user.userprofile {
                profileImageView.image = UIImage(data: imageData)
            }
        } else {
            // 로그인된 사용자가 없을 때 알림을 표시합니다.
//            showAlertForNoUserData()
            print("로그인된 사용자가 없습니다")
        }
    }
}

extension MyPageView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.configure(text: "정보 수정")
        case 1:
            cell.configure(text: "로그아웃")
        case 2:
            cell.configure(text: "회원 탈퇴")
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // 각 셀의 높이를 60으로 설정
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.mainBlack
        
        let titleLabel = UILabel()
        titleLabel.text = "계정"
        titleLabel.textColor = UIColor.mainWhite
        titleLabel.font = FontNames.mainFont2.font()
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 셀 선택에 따른 동작을 여기에 추가
        switch indexPath.row {
        case 0:
            onEditInfoSelected?()
            print("회원 정보 선택됨")
        case 1:
            showLogoutConfirmation()
        case 2:
            showAccountDeletionConfirmation()
            print("회원 탈퇴 선택됨")
        default:
            break
        }
    }
    
    private func showLogoutConfirmation() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
            self.performLogout()
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        if let viewController = self.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func performLogout() {
        // Perform logout operations here
        // For example, clear user data, navigate to the login screen, etc.
      
        UserDataManager.shared.logoutCurrentUser()
           fetchUserData() // 로그아웃 후 사용자 정보를 갱신
        
        let loginViewController = LoginView()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    private func showAccountDeletionConfirmation() {
        let alert = UIAlertController(title: "회원 탈퇴", message: "정말로 회원 탈퇴하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
            self.performAccountDeletion()
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        if let viewController = self.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    private func performAccountDeletion() {
        if let user = UserDataManager.shared.getCurrentLoggedInUser() {
            UserDataManager.shared.deleteUser(byId: user.id ?? "")
            // After deleting the user, we need to reset the logged in state
            user.isLoggedIn = false
            try? UserDataManager.shared.context.save()  // Save the context to reflect the changes
        }

        let loginViewController = LoginView()
        let navigationController = UINavigationController(rootViewController: loginViewController)

        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
